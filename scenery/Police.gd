# Police.gd
extends TextureRect
var this_room = "Police"

func _ready():
	$Leave.pressed.connect(_on_leave_pressed)
	$Assistant.pressed.connect(_on_assistant_pressed)
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):
	if(room_name == this_room):
		if GameManager.has_item(GameManager.ItemIDs.ROBE):
			GameManager.display_dialog(GameManager.events["assistant4"])
			$Assistant.hide()
		elif GameManager.knows_info(GameManager.InfoIDs.APPOINTMENT):
			GameManager.initiate_dialogue("assistant2")
		elif GameManager.knows_info(GameManager.InfoIDs.POLICE):
			GameManager.initiate_dialogue("assistant3")
		else:
			GameManager.initiate_dialogue("assistant")

func _on_assistant_pressed():
	if GameManager.knows_info(GameManager.InfoIDs.POLICE):
		var police = get_parent().get_node("Detective")
		police.texture = load("res://assets/Scenes/3a policeb.jpg")
		if !police.get_node("Papers").is_connected("pressed", police._on_papers_pressed):
			police.get_node("Papers").pressed.connect(police._on_papers_pressed)
			police.get_node("Drawers").pressed.connect(police._on_drawers_pressed)
		GameManager.initiate_dialogue("assistant3")
	else:
		GameManager.initiate_dialogue("assistant2")

func _on_leave_pressed():
	GameManager.change_room("Transit")
