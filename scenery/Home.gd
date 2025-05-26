# Home.gd
extends TextureRect
var this_room = "Home"
var returned_home

func _ready():
	$Door.pressed.connect(_on_door_pressed)
	$Dressers.pressed.connect(_on_dresser_pressed)
	$Hall.pressed.connect(_on_hall_pressed)
	$Hatch.pressed.connect(_on_hatch_pressed)
	$Window.pressed.connect(_on_window_pressed)
	$Fan.pressed.connect(_on_fan_pressed)
	GameManager.room_changed.connect(_on_room_changed)
	returned_home = false

func _on_room_changed(room_name: String):
	if(room_name == this_room && GameManager.left_home && !returned_home):
		returned_home = true
		GameManager.display_dialog(GameManager.events["home2"])
	elif(room_name == this_room && !GameManager.left_home):
		await get_tree().process_frame  
		GameManager.display_dialog(GameManager.events["home1"])

func _on_door_pressed():
	GameManager.change_room("Transit")

func _on_dresser_pressed():
	if(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS]):
		GameManager.obtain_item(GameManager.ItemIDs.LETTER)
		GameManager.learn_info(GameManager.InfoIDs.DAUGHTER)
		GameManager.obtain_item(GameManager.ItemIDs.TRANSPASS)
		GameManager.display_dialog(GameManager.events["dresser"])
		$Dressers.hide()

func _on_hall_pressed():
	if(!GameManager.inventory[GameManager.ItemIDs.DETECTOR]):
		GameManager.obtain_item(GameManager.ItemIDs.DETECTOR)
		GameManager.display_dialog(GameManager.events["hall"])
	else:
		GameManager.display_dialog(GameManager.events["hall2"])
		$Hall.hide()

func _on_hatch_pressed():
	if(!GameManager.inventory[GameManager.ItemIDs.LADDER]):
		GameManager.display_dialog(GameManager.events["hatch"])
	else:
		GameManager.change_room("Attic")

func _on_window_pressed():
	GameManager.display_dialog(GameManager.events["street"])
	$Window.hide()

func _on_fan_pressed():
	GameManager.insane(GameManager.insanity["ceiling-fan"])
	#$Fan.hide()
