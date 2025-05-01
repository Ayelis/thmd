# Mansion.gd
extends TextureRect

func _ready():
	print("Mansion area ready!")
	$Tunnel.pressed.connect(_on_tunnel_pressed)
	$Tunnels.pressed.connect(_on_tunnel_pressed)
	$Balcony.pressed.connect(_on_balcony_pressed)
	$Door.pressed.connect(_on_door_pressed)
	$Cultist.pressed.connect(_on_cultist_pressed)
func _on_tunnel_pressed():
	print("Tunnels checked!")
	if(!GameManager.knows_info(GameManager.InfoIDs.TUNNEL)):
		GameManager.display_dialog(GameManager.get_room_description("MANSION"))
	else:
		GameManager.display_dialog(GameManager.get_room_description("MANSION"))
		GameManager.change_room("Rotunda")
func _on_door_pressed():
	print("Door!")
	if(GameManager.inventory[GameManager.ItemIDs.KEY]):
		GameManager.display_dialog(GameManager.get_room_description("MANSION"))
		GameManager.change_room("Rotunda")
	else:
		GameManager.display_dialog(GameManager.get_room_description("MANSION"))
func _on_balcony_pressed():
	print("Balcony!")
	if(GameManager.inventory[GameManager.ItemIDs.ROPE]):
		GameManager.display_dialog(GameManager.get_room_description("MANSION"))
		GameManager.change_room("Rotunda")
	else:
		GameManager.display_dialog(GameManager.get_room_description("MANSION"))
func _on_cultist_pressed():
	print("Cultist speaks!")
	if(!GameManager.inventory[GameManager.ItemIDs.FLYER]):
		GameManager.display_dialog(GameManager.get_room_description("MANSION"))
		GameManager.obtain_item(GameManager.ItemIDs.FLYER)
	else:
		GameManager.display_dialog(GameManager.get_room_description("MANSION"))
