# Library.gd
extends TextureRect
var this_room = "Library"
var here_before

func _ready():
	$Shelves.pressed.connect(_on_shelves_pressed)
	$Chair.pressed.connect(_on_chair_pressed)
	$Computers.pressed.connect(_on_computer_pressed)
	GameManager.room_changed.connect(_on_room_changed)
	here_before = false

func _on_room_changed(room_name: String):
	if(room_name == this_room  && !here_before):
		if(!GameManager.inventory[GameManager.ItemIDs.LIBCARD]):
			GameManager.obtain_item(GameManager.ItemIDs.LIBCARD)
			GameManager.display_dialog(GameManager.events["library"])
		else:
			GameManager.display_dialog(GameManager.events["library2"])
			here_before = true

func _on_chair_pressed():
	GameManager.change_room("Transit")

func _on_shelves_pressed():
	if(!GameManager.knows_info(GameManager.InfoIDs.COMBO)):
		GameManager.learn_info(GameManager.InfoIDs.SHACK)
		GameManager.learn_info(GameManager.InfoIDs.COMBO)
		GameManager.display_dialog(GameManager.events["stacks"])
	else:
		GameManager.display_dialog(GameManager.events["stacks2"])
		GameManager.learn_info(GameManager.InfoIDs.COMBO)
		GameManager.learn_info(GameManager.InfoIDs.SHACK)

func _on_computer_pressed():
	GameManager.initiate_dialogue("computer")
