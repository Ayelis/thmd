# Mansion.gd
extends TextureRect

func _ready():
	$Cultist.pressed.connect(_on_cultist_pressed)
	$Leave.pressed.connect(_on_leave_pressed)
func _on_tunnel_pressed():
	if(GameManager.knows_info(GameManager.InfoIDs.TUNNEL)):
		GameManager.display_dialog(GameManager.events["tunnels"])
		GameManager.change_room("Rotunda")
func _on_door_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.ROBE]):
		GameManager.display_dialog(GameManager.events["has-robe"])
		GameManager.change_room("Rotunda")
	elif(GameManager.inventory[GameManager.ItemIDs.DAGGER]):
		GameManager.display_dialog(GameManager.events["knife"])
		GameManager.change_room("Rotunda")
	else:
		GameManager.display_dialog(GameManager.events["need-key"])
func _on_balcony_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.LADDER]):
		GameManager.display_dialog(GameManager.events["has-ladder"])
		GameManager.change_room("Rotunda")
	elif(GameManager.inventory[GameManager.ItemIDs.ROPE]):
		GameManager.display_dialog(GameManager.events["has-rope"])
		GameManager.change_room("Rotunda")
	else:
		GameManager.display_dialog(GameManager.events["balcony"])
func _on_cultist_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.GUN]):
		GameManager.display_dialog(GameManager.events["cultist-scared"])
		var cult = get_parent().get_node("Mansion")
		cult.texture = load("res://assets/Scenes/5a mansionb.jpg")
		cult.get_node("Tunnel").pressed.connect(cult._on_tunnel_pressed)
		cult.get_node("Tunnels").pressed.connect(cult._on_tunnel_pressed)
		cult.get_node("Balcony").pressed.connect(cult._on_balcony_pressed)
		cult.get_node("Door").pressed.connect(cult._on_door_pressed)
		cult.get_node("Cultist").hide()
	else:
		GameManager.display_dialog(GameManager.events["cultist"])
	GameManager.learn_info(GameManager.InfoIDs.CULTISTS)
func _on_leave_pressed():
	GameManager.change_room("Transit")
	$Cultist.hide()
