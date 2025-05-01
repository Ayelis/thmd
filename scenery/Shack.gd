# Shack.gd
extends TextureRect

func _ready():
	print("Shack area ready!")
	$Pail.pressed.connect(_on_pail_pressed)
	$Door.pressed.connect(_on_door_pressed)
	$Drawers.pressed.connect(_on_drawers_pressed)
	$Desk.pressed.connect(_on_desk_pressed)
	$Ceiling.pressed.connect(_on_ceiling_pressed)
func _on_desk_pressed():
	print("Desk searched!")
	GameManager.display_dialog(GameManager.rooms["SHACK"].itemdesc1)
func _on_drawers_pressed():
	print("Drawers checked!")
	GameManager.display_dialog(GameManager.rooms["SHACK"].itemdesc1)
	$Drawers.disabled = true
func _on_ceiling_pressed():
	print("Ceiling pondered!")
	GameManager.display_dialog(GameManager.insanity["ceiling"])
	GameManager.increase_insanity()
	$Ceiling.disabled = true
func _on_pail_pressed():
	print("Pail grabbed!")
	GameManager.display_dialog(GameManager.rooms["SHACK"].itemdesc1)
	GameManager.obtain_item(GameManager.ItemIDs.PAIL)
	$Pail.disabled = true
func _on_door_pressed():
	print("Door left!")
	GameManager.display_dialog(GameManager.rooms["SHACK"].itemdesc1)
	GameManager.change_room("Beach")
