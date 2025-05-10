# Mansion.gd
extends TextureRect

func _ready():
	print("Mansion area ready!")
	$Cultist.pressed.connect(_on_cultist_pressed)
	$Leave.pressed.connect(_on_leave_pressed)
func _on_tunnel_pressed():
	if(GameManager.knows_info(GameManager.InfoIDs.TUNNEL)):
		GameManager.display_dialog(GameManager.events["tunnels"])
		GameManager.change_room("Rotunda")
	print("Tunnels checked!")
func _on_door_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.DAGGER]):
		GameManager.display_dialog(GameManager.events["knife"])
		GameManager.change_room("Rotunda")
	elif(GameManager.inventory[GameManager.ItemIDs.ROBE]):
		GameManager.display_dialog(GameManager.events["has-robe"])
	else:
		GameManager.display_dialog(GameManager.events["need-key"])
	print("Door!")
func _on_balcony_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.ROPE]):
		GameManager.display_dialog(GameManager.events["has-rope"])
		GameManager.change_room("Rotunda")
	else:
		GameManager.display_dialog(GameManager.events["balcony"])
	print("Balcony!")
func _on_cultist_pressed():
	GameManager.display_dialog(GameManager.events["cultist"])
	GameManager.learn_info(GameManager.InfoIDs.CULTISTS)
	print("Cultist speaks!")
func _on_leave_pressed():
	GameManager.change_room("Transit")
	$Cultist.hide()
	print("Leave!")
