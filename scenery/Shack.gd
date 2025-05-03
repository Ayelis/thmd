# Shack.gd
extends TextureRect

func _ready():
	print("Shack area ready!")
	$Pail.pressed.connect(_on_pail_pressed)
	$Door.pressed.connect(_on_door_pressed)
	$Drawers.pressed.connect(_on_drawers_pressed)
	$Desk.pressed.connect(_on_desk_pressed)
	$Walls.pressed.connect(_on_walls_pressed)
	$Ceiling.pressed.connect(_on_ceiling_pressed)
func _on_desk_pressed():
	GameManager.learn_info(GameManager.InfoIDs.MANSION)
	GameManager.display_dialog(GameManager.events["shack-desk"])
	print("Desk searched!")
func _on_walls_pressed():
	GameManager.display_dialog(GameManager.events["shack2"])
	print("Walls searched!")
func _on_drawers_pressed():
	GameManager.display_dialog(GameManager.events["shack-drawers"])
	GameManager.obtain_item(GameManager.ItemIDs.ROPE)
	$Attic/Rope.hide()
	$Attic.texture = load("res://assets/Scenes/1b atticb.jpg")
	$Drawers.hide()
	print("Drawers checked!")
func _on_ceiling_pressed():
	GameManager.insane(GameManager.insanity["ceiling"])
	$Ceiling.hide()
	print("Ceiling pondered!")
func _on_pail_pressed():
	GameManager.obtain_item(GameManager.ItemIDs.PAIL)
	GameManager.display_dialog(GameManager.events["get-pail"])
	$Pail.hide()
	print("Pail grabbed!")
func _on_door_pressed():
	GameManager.change_room("Beach")
	GameManager.display_dialog(GameManager.events["dog"])
	print("Door left!")
