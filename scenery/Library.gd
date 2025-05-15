# Library.gd
extends TextureRect

func _ready():
	$Shelves.pressed.connect(_on_shelves_pressed)
	$Chair.pressed.connect(_on_chair_pressed)
	$Computers.pressed.connect(_on_computer_pressed)

func _on_chair_pressed():
	GameManager.change_room("Transit")
	# GameManager.display_dialog(GameManager.events["left-library"])

func _on_shelves_pressed():
	if(!GameManager.knows_info(GameManager.InfoIDs.SHACK)):
		GameManager.learn_info(GameManager.InfoIDs.SHACK)
		GameManager.learn_info(GameManager.InfoIDs.COMBO)
		GameManager.display_dialog(GameManager.events["stacks"])
	else:
		GameManager.display_dialog(GameManager.events["stacks2"])

func _on_computer_pressed():
	GameManager.initiate_dialogue("computer")
	GameManager.learn_info(GameManager.InfoIDs.APPOINTMENT)
