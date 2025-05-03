# Library.gd
extends TextureRect

func _ready():
	print("Library area ready!")
	$Shelves.pressed.connect(_on_shelves_pressed)
	$Chair.pressed.connect(_on_chair_pressed)
	$Computers.pressed.connect(_on_computer_pressed)

func _on_chair_pressed():
	print("Left chair!")
	GameManager.change_room("Transit")
	GameManager.display_dialog(GameManager.events["left-library"])

func _on_shelves_pressed():
	print("Shelves perused!")
	if(!GameManager.knows_info(GameManager.InfoIDs.SHACK)):
		GameManager.learn_info(GameManager.InfoIDs.SHACK)
		GameManager.learn_info(GameManager.InfoIDs.CULTISTS)
		GameManager.learn_info(GameManager.InfoIDs.COMBO)
		GameManager.display_dialog(GameManager.events["stacks"])
		$Shelves.hide()

func _on_computer_pressed():
	print("Computer accessed!")
	GameManager.display_dialog(GameManager.events["computer"])
	GameManager.learn_info(GameManager.InfoIDs.APPOINTMENT)
