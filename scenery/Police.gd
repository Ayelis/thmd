# Police.gd
extends TextureRect

func _ready():
	$Leave.pressed.connect(_on_leave_pressed)
	$Assistant.pressed.connect(_on_assistant_pressed)

func _on_assistant_pressed():
	if GameManager.knows_info(GameManager.InfoIDs.POLICE):
		var police = get_parent().get_node("Police2")
		police.texture = load("res://assets/Scenes/3a policeb.jpg")
		if !police.get_node("Papers").is_connected("pressed", police._on_papers_pressed):
			police.get_node("Papers").pressed.connect(police._on_papers_pressed)
			police.get_node("Drawers").pressed.connect(police._on_drawers_pressed)
		GameManager.initiate_dialogue("assistant3")
	else:
		GameManager.initiate_dialogue("assistant2")

func _on_leave_pressed():
	GameManager.change_room("Transit")
