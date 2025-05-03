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
	GameManager.insane(GameManager.insanity["birds"])
	GameManager.increase_insanity()
	$CloseBird.hide()
	$GroundBirds.hide()
	$FlyingBirds.hide()
func _on_sand_pressed():
	if(!GameManager.inventory[GameManager.ItemIDs.DETECTOR]):
		GameManager.display_dialog(GameManager.events["dagger"])
		GameManager.obtain_item(GameManager.ItemIDs.DAGGER)
		$Sand.hide()
	else:
		GameManager.display_dialog(GameManager.events["sand"])
	print("Sand examined!")
func _on_sky_pressed():
	print("Sky gazed!")
	GameManager.display_dialog(GameManager.events["sky"])
	$Sky.hide()
func _on_ocean_pressed():
	print("Ocean desired!")
	GameManager.increase_insanity()
	GameManager.insane(GameManager.insanity["ocean"])
	$Ocean.hide()
func _on_dog_pressed():
	GameManager.restore_sanity()
	GameManager.display_dialog(GameManager.events["dog"])
	print("Dog patted!")
func _on_shack_pressed():
	print("Shack examined!")
	GameManager.display_dialog(GameManager.events["shack"])
func _on_door_pressed():
	print("Door toggled!")
	if(GameManager.knows_info(GameManager.InfoIDs.COMBO)):
		GameManager.change_room("Shack")
		GameManager.display_dialog(GameManager.events["shack1"])
	else:
		GameManager.display_dialog(GameManager.events["door"])
