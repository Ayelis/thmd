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
	$Shack.pressed.connect(_on_shack_pressed)
	$Door.pressed.connect(_on_door_pressed)
	$Leave.pressed.connect(_on_leave_pressed)

func _on_birds_pressed():
	GameManager.insane(GameManager.insanity["birds"])
	texture = load("res://assets/Scenes/4a beachb.jpg")
	$CloseBird.hide()
	$GroundBirds.hide()
	$FlyingBirds.hide()
func _on_sand_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.DETECTOR]):
		GameManager.display_dialog(GameManager.events["dagger"])
		GameManager.obtain_item(GameManager.ItemIDs.DAGGER)
		$Sand.hide()
	elif(GameManager.inventory[GameManager.ItemIDs.PAIL]):
		GameManager.display_dialog(GameManager.events["digging"])
		GameManager.obtain_item(GameManager.ItemIDs.DAGGER)
		$Sand.hide()
	else:
		GameManager.display_dialog(GameManager.events["sand"])
func _on_sky_pressed():
	GameManager.display_dialog(GameManager.events["sky"])
	$Sky.hide()
func _on_ocean_pressed():
	GameManager.insane(GameManager.insanity["ocean"])
	$Ocean.hide()
func _on_dog_pressed():
	GameManager.restore_sanity()
	GameManager.learn_info(GameManager.InfoIDs.DOGGO)
	GameManager.display_dialog(GameManager.events["pet-dog"])
func _on_shack_pressed():
	GameManager.display_dialog(GameManager.events["shack"])
	$Shack.hide()
func _on_door_pressed():
	if(GameManager.knows_info(GameManager.InfoIDs.COMBO)):
		GameManager.change_room("Shack")
		GameManager.display_dialog(GameManager.events["shack1"])
	else:
		GameManager.display_dialog(GameManager.events["door"])
func _on_leave_pressed():
	GameManager.change_room("Transit")
