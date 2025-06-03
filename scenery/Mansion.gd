# Mansion.gd
extends TextureRect
var this_room = "Mansion"

func _ready():
	$Cultist.pressed.connect(_on_cultist_pressed)
	$Leave.pressed.connect(_on_leave_pressed)
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):
	# Show FBI or Police or Public or Cultist or Nothing
	if(room_name == this_room):
		var cult = get_parent().get_node("Mansion")
		if(!GameManager.inventory[GameManager.ItemIDs.FLYER]):
			GameManager.obtain_item(GameManager.ItemIDs.FLYER)
			GameManager.display_dialog(GameManager.events["mansion"])
		elif(GameManager.knows_info(GameManager.InfoIDs.FBI)):
			cult.texture = load("res://assets/Scenes/5a mansiond.jpg")
			if !cult.get_node("Tunnel").is_connected("pressed", cult._on_tunnel_pressed):
				cult.get_node("Tunnel").pressed.connect(cult._on_tunnel_pressed)
				cult.get_node("Tunnels").pressed.connect(cult._on_tunnel_pressed)
			GameManager.display_dialog(GameManager.events["fbi"])
			cult.get_node("Cultist").hide()
		elif(GameManager.knows_info(GameManager.InfoIDs.PUBLIC)):
			cult.texture = load("res://assets/Scenes/5a mansionc.jpg")
			if !cult.get_node("Tunnel").is_connected("pressed", cult._on_tunnel_pressed):
				cult.get_node("Tunnel").pressed.connect(cult._on_tunnel_pressed)
				cult.get_node("Tunnels").pressed.connect(cult._on_tunnel_pressed)
			GameManager.display_dialog(GameManager.events["public"])
			cult.get_node("Cultist").hide()
		else:
			cult.texture = load("res://assets/Scenes/5a mansionb.jpg")
			if !cult.get_node("Tunnel").is_connected("pressed", cult._on_tunnel_pressed):
				cult.get_node("Tunnel").pressed.connect(cult._on_tunnel_pressed)
				cult.get_node("Tunnels").pressed.connect(cult._on_tunnel_pressed)
				cult.get_node("Balcony").pressed.connect(cult._on_balcony_pressed)
				cult.get_node("Door").pressed.connect(cult._on_door_pressed)
			cult.get_node("Cultist").hide()

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
