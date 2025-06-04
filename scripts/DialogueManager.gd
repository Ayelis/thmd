extends Node

signal simple_message(text:String)
signal line_ready(text:String)

var dialogs_data := {}                # loaded JSON
var current_id:String = ""
var _on_complete:Callable = Callable()

# **INJECTED** UI references
var dialogue_node:Control
var options_container:Control
var text_label:RichTextLabel
var exit_button:TextureButton
var continue_button:TextureButton

var finish_prompt = false
var current_topic = ""
var current_node = ""
var current_callback = ""
var _post_result_next: String = ""
var _pending_ending: Dictionary = {}

func _on_continue_ending() -> void:
	if _pending_ending.is_empty():
		return
	
	var e = _pending_ending
	_pending_ending = {}
	
	# Trigger the actual ending
	GameManager.ending(
		e.text, 
		e.title if e.has("title") else "", 
		e.texture, 
		e.timbre if e.has("timbre") else ""
	)
	
	# Clean up
	_on_exit()

func load_dialogs(json:Dictionary) -> void:
	dialogs_data = json.get("dialogs", {})

# Scene calls this to wire up the actual UI controls:
func set_dialogue_node(panel:Control) -> void:
	dialogue_node     = panel
	options_container = panel.get_node("Panel/Options")
	text_label        = panel.get_node("Panel/Text")
	continue_button   = panel.get_node("Panel/Continue")
	exit_button       = panel.get_node("Panel/Exit")
	if continue_button.pressed.is_connected(_on_continue):
		continue_button.pressed.disconnect(_on_continue)
	continue_button.pressed.connect(_on_continue)
	continue_button.focus_mode = Control.FOCUS_NONE
	if exit_button.pressed.is_connected(_on_exit):
		exit_button.pressed.disconnect(_on_exit)
	exit_button.pressed.connect(_on_exit)
	exit_button.focus_mode = Control.FOCUS_NONE
	if not is_connected("line_ready", Callable(self, "_update_text")):
		connect("line_ready", Callable(self, "_update_text"))  # no flags needed :contentReference[oaicite:2]{index=2}
	if not GameManager.dialog_updated.is_connected(Callable(self, "_on_simple_message")):
		GameManager.dialog_updated.connect(_on_simple_message)  # Godot 4 style :contentReference[oaicite:3]{index=3}

func _on_simple_message(text:String) -> void:
	await get_tree().process_frame  
	if is_instance_valid(dialogue_node):  # Critical check
		dialogue_node.show()
	else:
		printerr("Dialogue node is freed! Re-initializing...")
	emit_signal("line_ready", text)           # pump into UI
	exit_button.show()                        # let player close
	if not GameManager.is_connected("dialog_updated", Callable(self, "emit_simple_message")):
		GameManager.connect("dialog_updated", Callable(self, "emit_simple_message"))

func emit_simple_message(text:String)->void:
	emit_signal("simple_message", text)

func _on_simple_text(text:String) -> void:
	dialogue_node.show()
	emit_signal("line_ready", text)
	# leave exit visible so player can close
	exit_button.show()

func start_structured(topic_id: String, on_complete: Callable = Callable(), node_id: String = "root") -> void:
	if not dialogue_node:
		push_error("Dialogue UI not set—call set_dialogue_node() first.")
		return

	if not dialogs_data.has(topic_id):
		push_warning("Dialog topic not found: %s" % topic_id)
		return

	var topic_data = dialogs_data[topic_id]

	if not topic_data.has(node_id):
		push_warning("Dialog node ID not found: %s in topic %s" % [node_id, topic_id])
		return

	# Store for navigation
	current_topic = topic_id
	current_node = node_id
	current_callback = on_complete

	# Proceed to render the current node
	_process_block(topic_data[node_id])

func _process_block(block: Dictionary) -> void:
	_clear_options()
	# Reset button visibility
	continue_button.hide()
	exit_button.hide()
	if block.has("prompt"):
		emit_signal("line_ready", block.prompt)

	elif block.has("result"):
		emit_signal("line_ready", block.result)
		if block.has("learn"):
			GameManager.learn_info(GameManager.InfoIDs[block.learn])
		if block.has("forget"):
			GameManager.forget_info(GameManager.InfoIDs[block.forget])
		if block.has("give"):
			GameManager.obtain_item(GameManager.ItemIDs[block.give])
		if block.has("next") and block.get("next") != null:
			_post_result_next = block.get("next")
			continue_button.show()
			return
#		elif block.has("ending"):
#			emit_signal("line_ready", block.result)  # Make sure text shows first
#			await get_tree().create_timer(0.1).timeout
#			await get_tree().process_frame  
#			var e = block.ending
#			GameManager.ending(e.text, e.title if e.has("title") else "", e.texture, e.timbre if e.has("timbre") else "")
#			finish_prompt = true
#			return  # Skip further processing
		elif block.has("ending"):
			emit_signal("line_ready", block.result)
			continue_button.show()
			exit_button.hide()
			_pending_ending = block.ending
			if not continue_button.pressed.is_connected(_on_continue_ending):
				continue_button.pressed.connect(_on_continue_ending, CONNECT_ONE_SHOT)
			return  # Skip further processing
		else:
			exit_button.show()
			finish_prompt = true

	if block.has("learn"):
		GameManager.learn_info(GameManager.InfoIDs[block.learn])

	if block.has("give"):
		GameManager.obtain_item(GameManager.ItemIDs[block.give])

	if finish_prompt:
		finish_prompt = false
		_finish()
		return

	if block.has("options"):
		for opt in block.options:
			if opt.has("ifnot_all"):
				var should_skip = true
				for info_id in opt.ifnot_all:
					if not GameManager.knows_info(GameManager.InfoIDs[info_id]):
						should_skip = false
						break
				if should_skip:
					continue
			if opt.has("conditions_all"):
				var all_conditions_met = true
				for cond_id in opt.conditions_all:
					if typeof(cond_id)==TYPE_STRING and GameManager.InfoIDs.has(cond_id):
						if not GameManager.knows_info(GameManager.InfoIDs[cond_id]):
							all_conditions_met = false
							break
					elif typeof(cond_id)==TYPE_STRING and GameManager.ItemIDs.has(cond_id):
						if not GameManager.has_item(GameManager.ItemIDs[cond_id]):
							all_conditions_met = false
							break
				if not all_conditions_met:
					continue

			if opt.has("condition") and not _check_condition(opt.condition):
				continue
			if opt.has("ifnot") and GameManager.knows_info(GameManager.InfoIDs[opt["ifnot"]]):
				continue
			var btn = Button.new()
			btn.text = opt.text
			btn.tooltip_text = opt.get("tooltip", "")
			btn.pressed.connect(func(): _on_option(opt))
			btn.alignment = HORIZONTAL_ALIGNMENT_LEFT #Doesn't work!! D:<
			options_container.add_child(btn)
		options_container.show()
		return

	if block.has("newscene") and block.has("chain"):
		GameManager.change_room(block.newscene)
		_on_exit()
		GameManager.initiate_dialogue(block.chain)
	elif block.has("newscene") and block.has("room"):
		GameManager.change_room(block.newscene)
		_on_exit()
		#GameManager.display_dialog(GameManager.events[block.room])
	elif block.has("newscene"):
		GameManager.change_room(block.newscene)
		_on_exit()
	elif block.has("next") and block.get("next") == null:
		_on_exit()
	elif block.has("next"):
		start_structured(current_topic, _on_complete, block.get("next"))
	else:
		exit_button.show()
		_finish()

func _on_option(opt:Dictionary) -> void:
	_clear_options()
	exit_button.hide()
	_process_block(opt)

func _on_continue() -> void:
	if _post_result_next != "":
		var nid = _post_result_next
		_post_result_next = ""
		start_structured(current_topic, _on_complete, nid)
	else:
		exit_button.show()
		continue_button.hide()

func _on_exit() -> void:
	continue_button.hide()
	exit_button.hide()
	dialogue_node.hide()
	GameManager.emit_signal("dialogue_closed")
	_finish()

func _update_text(t:String) -> void:
	text_label.text = t

func _check_condition(cond) -> bool:
	if typeof(cond)==TYPE_STRING and GameManager.ItemIDs.has(cond):
		return GameManager.has_item(GameManager.ItemIDs[cond])
	if typeof(cond)==TYPE_STRING and GameManager.InfoIDs.has(cond):
		return GameManager.knows_info(GameManager.InfoIDs[cond])
	return GameManager.player_state.get(cond,false)

func _clear_options() -> void:
	for c in options_container.get_children():
		c.queue_free()

func _finish() -> void:
	if _on_complete:
		_on_complete.call()
		_on_complete = Callable()
