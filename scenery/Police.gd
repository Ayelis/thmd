# Police.gd
extends TextureRect

func _ready():
	print("Police area ready!")
	$Detective.pressed.connect(_on_detective_pressed)

func _on_computer_pressed():
	GameManager.display_dialog(GameManager.events["police-computer"])
	print("Computer!")
func _on_drawers_pressed():
	GameManager.display_dialog(GameManager.events["police-drawer"])
	GameManager.obtain_item(GameManager.ItemIDs.BULLHORN)
	print("Drawers!")
func _on_papers_pressed():
	GameManager.display_dialog(GameManager.events["papers"])
	GameManager.obtain_item(GameManager.ItemIDs.KEY)
	print("Papers!")
func _on_detective_pressed():
	if(!GameManager.knows_info(GameManager.InfoIDs.POLICE)):
		GameManager.display_dialog(GameManager.dialogs["detective"])
		texture = load("res://assets/Scenes/3a policeb.jpg")
		GameManager.learn_info(GameManager.InfoIDs.POLICE)
		$Computer.pressed.connect(_on_computer_pressed)
		$Papers.pressed.connect(_on_papers_pressed)
		$Drawers.pressed.connect(_on_drawers_pressed)
	elif(GameManager.inventory[GameManager.ItemIDs.KEY]):
		GameManager.display_dialog(GameManager.events["evidence"])
		GameManager.change_room("Evidence")
	else:
		GameManager.change_room("Transit")
	print("Detective!")
