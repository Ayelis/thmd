extends Control

signal dialogue_closed

func _ready():
	# Connect signals
	GameManager.dialogue_updated.connect(_on_dialogue_updated)
	
	# Theme setup
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)
	
	# Connect exit button
	$Panel/Exit.pressed.connect(_hide)
	
	# Start hidden
	visible = false
	print("Dialogue ready")

func _on_dialogue_updated(text: String):
	# Update the RichTextLabel with the new dialogue
	$Panel/Text.text = text
	_show()  # Make sure the panel is visible when new text arrives

func _update_theme(is_dark_mode: bool):
	var tex_path = "res://assets/UI/%s_panel.png" % ["dark" if is_dark_mode else "light"]
	$Panel.texture = load(tex_path)
	if is_dark_mode:
		$Panel/Text.add_theme_color_override("default_color", Color(1, 1, 1))
	else:
		$Panel/Text.add_theme_color_override("default_color", Color(0, 0, 0))

func _show():
	visible = true
	print("Dialogue open!")

func _hide():
	visible = false
	GameManager.emit_signal("dialogue_closed")  # Notify GameManager
	print("Dialogue closed!")

func _input(event):
	if event.is_action_pressed("ui_accept"):  # Enter/Return/Space key
		_hide()
