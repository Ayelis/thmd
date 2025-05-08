# Police.gd
extends TextureRect

func _ready():
	print("Police area ready!")
	$Detective.pressed.connect(_on_detective_pressed)
	$Computer.pressed.connect(_on_computer_pressed)
	$Leave.pressed.connect(_on_leave_pressed)

func _on_computer_pressed():
	GameManager.display_dialog(GameManager.events["police-computer"])
	print("Computer!")
func _on_drawers_pressed():
	if(!GameManager.has_item(GameManager.ItemIDs.BULLHORN)):
		GameManager.display_dialog(GameManager.events["police-drawer"])
		GameManager.obtain_item(GameManager.ItemIDs.BULLHORN)
	print("Drawers!")
func _on_papers_pressed():
	if(!GameManager.has_item(GameManager.ItemIDs.KEY)):
		GameManager.display_dialog(GameManager.events["papers"])
		GameManager.obtain_item(GameManager.ItemIDs.KEY)
	print("Papers!")
func _on_detective_pressed():
	if(!GameManager.knows_info(GameManager.InfoIDs.POLICE)):
		GameManager.initiate_dialogue("detective")
		GameManager.learn_info(GameManager.InfoIDs.POLICE)
	elif(GameManager.inventory[GameManager.ItemIDs.KEY]):
		GameManager.display_dialog(GameManager.events["evidence"])
		GameManager.change_room("Evidence")
	else:
		GameManager.change_room("Transit")
	print("Detective!")
func _on_leave_pressed():
	GameManager.change_room("Transit")
	print("Leave!")
