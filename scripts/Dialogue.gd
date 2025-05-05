extends Control

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
	print("Dialogue ready")
	
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

func _hide():
	visible = false
	GameManager.emit_signal("dialogue_closed")  # Notify GameManager

func _input(event):
	if event.is_action_pressed("ui_accept"):  # Enter/Return/Space key
		var opts = get_node("Panel/Options")
		# don’t close if options are up
		if opts.visible and opts.get_child_count() > 0:
			return
		hide()
