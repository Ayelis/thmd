# Police.gd
extends TextureRect

func _ready():
	$Detective.pressed.connect(_on_detective_pressed)
	$Computer.pressed.connect(_on_computer_pressed)
	$Leave.pressed.connect(_on_leave_pressed)

func _on_computer_pressed():
	GameManager.display_dialog(GameManager.events["police-computer"])
func _on_drawers_pressed():
	if(!GameManager.has_item(GameManager.ItemIDs.BULLHORN)):
		GameManager.initiate_dialogue("police-drawer")
		$Drawers.hide()
func _on_papers_pressed():
	if(!GameManager.has_item(GameManager.ItemIDs.KEY)):
		GameManager.initiate_dialogue("police-papers")
		GameManager.obtain_item(GameManager.ItemIDs.KEY)
		$Papers.hide()
func _on_detective_pressed():
	if(!GameManager.knows_info(GameManager.InfoIDs.POLICE)):
		GameManager.initiate_dialogue("detective")
		GameManager.learn_info(GameManager.InfoIDs.POLICE)
	elif(GameManager.inventory[GameManager.ItemIDs.KEY]):
		GameManager.display_dialog(GameManager.events["evidence"])
		GameManager.change_room("Evidence")
	else:
		GameManager.change_room("Transit")
func _on_leave_pressed():
	GameManager.change_room("Transit")
