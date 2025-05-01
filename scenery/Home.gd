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
	GameManager.display_dialog(GameManager.get_room_description("HOME"))

func _on_door_pressed():
	print("Door opened!")
	GameManager.change_room("Transit")

func _on_dresser_pressed():
	print("Dresser accessed!")
	if(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS]):
		GameManager.obtain_item(GameManager.ItemIDs.LETTER)
		GameManager.obtain_item(GameManager.ItemIDs.TRANSPASS)
		GameManager.obtain_item(GameManager.ItemIDs.LIBCARD)
		GameManager.display_dialog(GameManager.get_room_description("HOME"))
		$Dressers.disabled = true

func _on_hall_pressed():
	print("Hall explored!")
	GameManager.obtain_item(GameManager.ItemIDs.DETECTOR)
	GameManager.display_dialog(GameManager.get_room_description("HOME"))
	$Hall.disabled = true

func _on_hatch_pressed():
	print("Hatch pondered!")
	if(!GameManager.inventory[GameManager.ItemIDs.PAIL]):
		GameManager.change_room("Attic")
		GameManager.display_dialog(GameManager.get_room_description("HOME"))
	else:
		GameManager.display_dialog(GameManager.get_room_description("HOME"))

func _on_window_pressed():
	print("Window peered!")
	GameManager.display_dialog(GameManager.get_room_description("HOME"))
	$Window.disabled = true

func _on_fan_pressed():
	print("Fan gazed!")
	GameManager.display_dialog(GameManager.insanity["ceiling-fan"])
	GameManager.increase_insanity()
	$Fan.disabled = true
