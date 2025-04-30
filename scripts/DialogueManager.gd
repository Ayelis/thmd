# DialogueManager.gd
extends Node

signal dialogue_closed

var current_room_dialogue := {
	"home": {
		"text": "This is your safe space. The door leads to the transit station.",
		"options": []
	},
	"transit": {
		"text": "A busy station. Where to next?",
		"options": [
			{"text": "Police Station", "action": "_go_to_police"},
			{"text": "Library", "action": "_go_to_library"}
		]
	}
}

func show_room_dialogue(room_key: String):
	var dialogue = current_room_dialogue.get(room_key, {})
	
	# Update UI
	$DialogueManager/DialogBox/Text.text = dialogue.get("text", "")
	
	# Clear old options
	for child in $DialogueManager/DialogBox/Options.get_children():
		child.queue_free()
	
	# Add new options
	for opt in dialogue.get("options", []):
		var btn = Button.new()
		btn.text = opt["text"]
		btn.pressed.connect(Callable(self, opt["action"]))
		$DialogueManager/DialogBox/Options.add_child(btn)
	
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
