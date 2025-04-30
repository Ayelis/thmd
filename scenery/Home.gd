# Home.gd
extends TextureRect

func _ready():
	print("Home ready!")
	$Door.pressed.connect(_on_door_pressed)
	$Dressers.pressed.connect(_on_dresser_pressed)

func _on_door_pressed():
	print("Door opened!")
	GameManager.change_room("Transit")

func _on_dresser_pressed():
	print("Dresser accessed!")
	if(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS]):
		GameManager.obtain_item(GameManager.ItemIDs.LETTER)
		GameManager.obtain_item(GameManager.ItemIDs.TRANSPASS)
		GameManager.obtain_item(GameManager.ItemIDs.LIBCARD)
