# Home.gd
extends TextureRect

func _ready():
	print("Home ready!")
	$Door.pressed.connect(_on_door_pressed)
	$Dressers.pressed.connect(_on_dresser_pressed)
	$Hall.pressed.connect(_on_hall_pressed)
	$Hatch.pressed.connect(_on_hatch_pressed)
	$Window.pressed.connect(_on_window_pressed)
	$Fan.pressed.connect(_on_fan_pressed)
	GameManager.display_dialog(GameManager.events["home2"])

func _on_door_pressed():
	print("Door opened!")
	GameManager.change_room("Transit")

func _on_dresser_pressed():
	print("Dresser accessed!")
	if(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS] && !GameManager.inventory[GameManager.ItemIDs.LETTER]):
		GameManager.obtain_item(GameManager.ItemIDs.LETTER)
		GameManager.learn_info(GameManager.InfoIDs.DAUGHTER)
		GameManager.display_dialog(GameManager.events["get-letter"])
	elif(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS]):
		GameManager.obtain_item(GameManager.ItemIDs.TRANSPASS)
		GameManager.display_dialog(GameManager.events["dresser"])
		$Dressers.hide()

func _on_hall_pressed():
	print("Hall explored!")
	GameManager.obtain_item(GameManager.ItemIDs.DETECTOR)
	GameManager.display_dialog(GameManager.events["hall"])
	$Hall.hide()

func _on_hatch_pressed():
	print("Hatch pondered!")
	if(!GameManager.inventory[GameManager.ItemIDs.PAIL]):
		GameManager.display_dialog(GameManager.events["hatch"])
	else:
		GameManager.change_room("Attic")
		GameManager.display_dialog(GameManager.events["attic"])

func _on_window_pressed():
	print("Window peered!")
	GameManager.display_dialog(GameManager.events["street"])
	$Window.hide()

func _on_fan_pressed():
	print("Fan gazed!")
	GameManager.insane(GameManager.insanity["ceiling-fan"])
	GameManager.increase_insanity()
	$Fan.hide()
