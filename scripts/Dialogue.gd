extends Control

signal dialogue_opened
signal dialogue_closed

func _ready():
	DialogueManager.set_dialogue_node(self)
	
	# Connect to both systems
	DialogueManager.line_ready.connect(_on_dialogue_updated)  # Structured
	DialogueManager.simple_message.connect(_on_dialogue_updated)  # Simple
	
	# Theme setup
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)
	# Connect exit button
	$Panel/Exit.pressed.connect(_hide)
	
	# Start hidden
	visible = false

func _on_dialogue_updated(text: String):
	$Panel/Text.text = text
	_show()

func _update_theme(is_dark_mode: bool):
	var tex_path = "res://assets/UI/%s_panel.png" % ["dark" if is_dark_mode else "light"]
	$Panel.texture = load(tex_path)
	if is_dark_mode:
		$Panel/Text.add_theme_color_override("default_color", Color(1, 1, 1))
	else:
		$Panel/Text.add_theme_color_override("default_color", Color(0, 0, 0))

func _show():
	visible = true
	emit_signal("dialogue_opened")

func _hide():
	visible = false
	emit_signal("dialogue_closed")

func _input(event):
	# only care about key events
	if event is InputEventKey and event.is_action_pressed("ui_accept"):
		# 1) if choice‐options are up, do nothing
		if DialogueManager.options_container.visible and DialogueManager.options_container.get_child_count() > 0:
			return

		# 2) if Continue button is visible, treat Enter as “continue”
		if DialogueManager.continue_button.visible:
			DialogueManager._on_continue()
			# consume so default hide() won’t run
			#get_tree().set_input_as_handled()
			return

		# 3) otherwise if Exit button is visible, treat Enter as “exit”
		if DialogueManager.exit_button.visible:
			DialogueManager._on_exit()
			_hide()
			#get_tree().set_input_as_handled()
			return
