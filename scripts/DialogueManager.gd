# DialogueManager.gd (autoload)
extends Node
@warning_ignore("unused_signal")
signal dialogue_closed
signal line_ready(text:String)
var dialogue_node: Node = null
signal simple_message(text: String)  # For one-line messages

# ——— new fields for structured dialog ——
var dialogs_data:Dictionary = {}        # load your JSON into this
var _queue:PackedStringArray = []        # flattened lines
var _on_complete: Callable = Callable()  # acts like a “do nothing”
var current_key = "" 					# Track the dialogue we're using

func _ready():
	# existing UI hookups
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)
	GameManager.dialog_updated.connect(_on_simple_message)
	if(dialogue_node):
		dialogue_node.get_node("Panel/Exit").pressed.connect(_on_exit_pressed)

	# hookup new “advance‐line” signal to UI
	connect("line_ready", Callable(self, "_on_dial_updated"))

func set_dialogue_node(node: Node):
	dialogue_node = node

# ——— new API ——
func load_dialogs(json:Dictionary) -> void:
	dialogs_data = json["dialogs"]
	print("Loaded %d dialogs" % dialogs_data.size())  # Debug print

func start_structured(dialog_id: String, on_complete: Callable = Callable()):
	current_key = dialog_id
	print("SS")
	if not dialogue_node:
		push_error("No dialogue_node assigned")
		return
	# always show the window and hide Exit while picking
	dialogue_node.show()
	dialogue_node.get_node("Panel/Exit").hide()
	# fetch and normalize the tree
	var tree = dialogs_data.get(dialog_id, {})
	if tree.has("root"):
		tree = tree["root"]		# ← unwrap the root block
	if tree.is_empty():
		push_warning("no dialog for id %s" % dialog_id)
		return
	# clear any old buttons & text
	var opts_n = dialogue_node.get_node("Panel/Options")
	_clear_options(opts_n)
	opts_n.hide()
	# immediately set the prompt text
	if tree.has("prompt"):
		dialogue_node.get_node("Panel/Text").text = tree["prompt"]
	# if there are choices, build them and bail out
	if tree.has("options"):
		show_structured_options(tree["options"])
		return
	# otherwise queue up the result as before
	_queue.clear()
	if tree.has("result"):
		_queue.append(tree["result"])
	_emit_next_line()

func _emit_next_line() -> void:
	print("ENL")
	if _queue.is_empty():
		print("empty q")
		emit_signal("dialogue_closed")
		if _on_complete:
			_on_complete.call()
		return
	print("q")
	var next_content = _queue[0]
	_queue.remove_at(0)
	
	# Handle both string and dictionary content safely
	if typeof(next_content) == TYPE_DICTIONARY:
		var opts = next_content.get("options")
		if typeof(opts) in [TYPE_ARRAY, TYPE_DICTIONARY]:
			show_structured_options(opts)
		else:
			push_warning("Invalid options format: %s" % str(opts))
			# Maintain original behavior for other dictionaries
			emit_signal("line_ready", str(next_content))
	else:
		# Handle all other cases (strings) as before
		emit_signal("line_ready", str(next_content))
	
	# Keep original options visibility logic
	var options_node = dialogue_node.get_node("Panel/Options")
	options_node.visible = typeof(next_content) == TYPE_DICTIONARY && next_content.has("options")
	dialogue_node.show()

func show_structured_options(options: Array):
	var opts_n = dialogue_node.get_node("Panel/Options")
	_clear_options(opts_n)

	for opt_dict in options:
		if opt_dict.has("condition") and not _check_option_conditions(opt_dict["condition"]):
			continue
		var btn = Button.new()
		btn.text = opt_dict["text"]
		if opt_dict.has("tooltip"):
			btn.tooltip_text = opt_dict["tooltip"]
		btn.pressed.connect(func(): _on_option_selected(opt_dict["next"]))
		opts_n.add_child(btn)
	opts_n.show()

func _on_option_selected(next_key: String):
	print("Option selected: ", next_key)
	var next_data = dialogs_data.get(current_key, {})
	if next_data.has(next_key):
		next_data = next_data[next_key]
	if next_data.is_empty():
		push_warning("no dialog for id %s" % next_key)
		return
	# clear any old buttons & text
	var opts_n = dialogue_node.get_node("Panel/Options")
	_clear_options(opts_n)
	opts_n.hide()
	print(next_data)
	if next_data.has("learn"):
		print("Learn!")
		GameManager.learn_info(next_data["learn"])
	if next_data.has("reselect"):
		print("Reselect!")
		current_key = next_data["reselect"]
		_on_option_selected(next_data["reselect"])
	if next_data.has("result"):
		print("Result!")
		dialogue_node.get_node("Panel/Text").text = next_data["result"]
		emit_signal("line_ready", next_data["result"])
	# Handle chained dialogues
	if next_data.has("next"):
		print("Next!")
		start_structured(next_data["next"])
	else:
		print("End!")
		# Only hide if this is the end
		var options_node = dialogue_node.get_node("Panel/Options")
		_clear_options(options_node)
		dialogue_node.get_node("Panel/Exit").show()

# call this from your UI when player presses “next”
func advance() -> void:
	print("Adv")
	_emit_next_line()

# ——— existing handlers ——
func _on_exit_pressed():
	if(dialogue_node):
		dialogue_node.visible = false
	emit_signal("dialogue_closed")

func _on_dial_updated(text: String):
	if dialogue_node:
		dialogue_node.get_node("Panel/Text").text = text

func _on_simple_message(text: String):
	print("OSM")
	emit_signal("simple_message", text)  # This forwards to Dialogue.gd
	if dialogue_node:
		# dialogue_node.get_node("Panel/Text").text = text
		dialogue_node.show()

# theme code unchanged
func _update_theme(is_dark_mode: bool):
	var tex = "res://assets/UI/%s_paper.png" % ["dark" if is_dark_mode else "light"]
	if dialogue_node:
		dialogue_node.get_node("Panel").texture = load(tex)

func show_room_dialogue(room_key: String):
	print("SRD")
	if not dialogue_node:
		return
	var room_data = GameManager.rooms.get(room_key, null)
	if room_data == null:
		push_error("Invalid room key: %s" % room_key)
		return
	# Set room context
	dialogue_node.current_room_key = room_key
	# Show main description
	dialogue_node.get_node("Panel/Text").text = room_data.get("description", "Nothing to see here.")
	# Show options
	var dialog = GameManager.dialogs.get(room_key, {}).get("root", {})
	show_structured_options(dialog.get("options", []))
	var options_node = dialogue_node.get_node("Panel/Options")
	options_node.show()
	dialogue_node.show()
	print("Show!")

func _on_structured_option_selected(next_key: String):
	print("OSOS")
	if not dialogue_node:
		return
	# Handle room-specific dialogues
	if has_method("_handle_room_option") and dialogue_node.current_room_key:
		_handle_room_option(next_key)
		return
	# Handle general structured dialogues
	var next_data = dialogs_data.get(next_key, {})
	_process_dialogue_result(next_data)
	print("Processed")

func _handle_room_option(next_key: String):
	print("HRO")
	var next_data = GameManager.dialogs.get(dialogue_node.current_room_key, {}).get(next_key, {})
	if next_data.is_empty():
		push_warning("Missing dialog entry: %s in room %s" % [next_key, dialogue_node.current_room_key])
		return
	_process_dialogue_result(next_data)
	print("Processed")

func _process_dialogue_result(result_data: Dictionary):
	if result_data.has("result"):
		dialogue_node.get_node("Panel/Text").text = result_data["result"]
	elif result_data.has("learn"):
		GameManager.learn_info(result_data["learn"])
	elif result_data.has("action"):
		GameManager.perform_action(result_data["action"])
	if result_data.has("next"):
		start_structured(result_data["next"])
	else:
		# Clear options unless it's a multi-part dialogue
		var opts_n = dialogue_node.get_node("Panel/Options")
		_clear_options(opts_n)
		opts_n.hide()
		dialogue_node.get_node("Panel/Exit").show()

func _check_option_conditions(opt: String) -> bool:
	print("COC")
	if not GameManager.has_item(GameManager.ItemIDs[opt]):
		return false
	return true

func _clear_options(options_node: Control):
	for child in options_node.get_children():
		child.queue_free()

func _on_dialogue_closed():
	if dialogue_node:
		dialogue_node.hide()
	emit_signal("dialogue_closed")
