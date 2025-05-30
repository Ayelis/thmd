# Police.gd
extends TextureRect
var this_room = "Detective"

func _ready():
	$Detective.pressed.connect(_on_detective_pressed)
	$Computer.pressed.connect(_on_computer_pressed)
	$Leave.pressed.connect(_on_leave_pressed)
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):
	if(room_name == this_room):
		if GameManager.knows_info(GameManager.InfoIDs.POLICE):
			var police = get_parent().get_node("Detective")
			police.texture = load("res://assets/Scenes/3a policeb.jpg")
			if !police.get_node("Papers").is_connected("pressed", police._on_papers_pressed):
				police.get_node("Papers").pressed.connect(police._on_papers_pressed)
				police.get_node("Drawers").pressed.connect(police._on_drawers_pressed)
			GameManager.display_dialog(GameManager.events["detective2"])
		else:
			GameManager.initiate_dialogue("detective")

func _on_computer_pressed():
	GameManager.display_dialog(GameManager.events["police-computer"])
func _on_drawers_pressed():
	if(!GameManager.has_item(GameManager.ItemIDs.BULLHORN)):
		GameManager.initiate_dialogue("police-drawer")
func _on_papers_pressed():
	if(!GameManager.has_item(GameManager.ItemIDs.KEY)):
		GameManager.initiate_dialogue("police-papers")
func _on_detective_pressed():
	if(!GameManager.knows_info(GameManager.InfoIDs.POLICE)):
		GameManager.initiate_dialogue("detective")
		GameManager.forget_info(GameManager.InfoIDs.APPOINTMENT)
	elif(GameManager.inventory[GameManager.ItemIDs.KEY]):
		GameManager.change_room("Police")
	else:
		GameManager.change_room("Police")
func _on_leave_pressed():
	GameManager.change_room("Police")
