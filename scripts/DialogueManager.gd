# DialogueManager.gd
extends Node

signal dialogue_closed

func ready():
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)	
	GameManager.dialogue_updated.connect(_on_dial_updated)
	$Panel/Exit.pressed.connect(_on_exit_pressed)

func _update_theme(is_dark_mode: bool):
	var tex_path = "res://assets/UI/%s_paper.png" % ["dark" if is_dark_mode else "light"]
	$Panel.texture = load(tex_path)

func _on_exit_pressed():
	$DialogueManager.visible = false
	print("Inventory closed!")

func _on_dial_updated(text: String):
	$DialogueManager/Panel/Text.text = "Hi!"  #dialogue.get("text", "")

func show_room_dialogue(room_key: String):
	# Update UI
	$DialogueManager/Panel/Text.text = GameManager.rooms[room_key].description
	# Clear old options
	for child in $DialogueManager/DialogBox/Options.get_children():
		child.queue_free()
	# Show the box
	$DialogueManager/DialogBox.show()

func _on_close_pressed():
	$DialogueManager/DialogBox.hide()
	emit_signal("dialogue_closed")

func _go_to_police():
	GameManager.request_room_change("Police")
	$DialogueManager/DialogBox.hide()

func _go_to_library():
	GameManager.request_room_change("Library")
	$DialogueManager/DialogBox.hide()
