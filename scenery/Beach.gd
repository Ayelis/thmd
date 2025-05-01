# Beach.gd
extends TextureRect

func _ready():
	$CloseBird.pressed.connect(_on_birds_pressed)
	$GroundBirds.pressed.connect(_on_birds_pressed)
	$FlyingBirds.pressed.connect(_on_birds_pressed)
	$Sand.pressed.connect(_on_sand_pressed)
	$Sky.pressed.connect(_on_sky_pressed)
	$Dog.pressed.connect(_on_dog_pressed)
	$Ocean.pressed.connect(_on_ocean_pressed)
	$Shack.pressed.connect(_on_door_pressed)
	$Door.pressed.connect(_on_door_pressed)
	print("Beach area ready!")

func _on_birds_pressed():
	print("Tracks pondered!")
	GameManager.display_dialog(GameManager.insanity["birds"])
	GameManager.increase_insanity()
	$CloseBird.disabled = true
	$GroundBirds.disabled = true
	$FlyingBirds.disabled = true
func _on_sand_pressed():
	print("Sand examined!")
	GameManager.display_dialog(GameManager.get_room_description("BEACH"))
	GameManager.obtain_item(GameManager.ItemIDs.DAGGER)
	GameManager.obtain_item(GameManager.ItemIDs.KEY)
	$Sand.disabled = true
func _on_sky_pressed():
	print("Sky gazed!")
	GameManager.display_dialog(GameManager.get_room_description("BEACH"))
	$Sky.disabled = true
func _on_ocean_pressed():
	print("Ocean desired!")
	GameManager.increase_insanity()
	GameManager.display_dialog(GameManager.insanity["ocean"])
	$Ocean.disabled = true
func _on_dog_pressed():
	print("Dog patted!")
	GameManager.decrease_insanity()
	GameManager.display_dialog(GameManager.get_room_description("BEACH"))
func _on_shack_pressed():
	print("Shack examined!")
	GameManager.display_dialog(GameManager.get_room_description("BEACH"))
func _on_door_pressed():
	print("Door toggled!")
	if(GameManager.knows_info(GameManager.InfoIDs.COMBO)):
		GameManager.change_room("Shack")
		GameManager.display_dialog(GameManager.get_room_description("BEACH"))
	else:
		GameManager.display_dialog(GameManager.get_room_description("BEACH"))
