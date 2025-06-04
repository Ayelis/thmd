# Mansion.gd
extends TextureRect
var this_room = "Mansion"
@onready var cult = get_parent().get_node("Mansion")

func _ready():
	$Cultist.pressed.connect(_on_cultist_pressed)
	$Tunnel.pressed.connect(_on_tunnel_pressed)
	$Tunnels.pressed.connect(_on_tunnel_pressed)
	$Balcony.pressed.connect(_on_balcony_pressed)
	$Door.pressed.connect(_on_door_pressed)
	$Public.pressed.connect(_on_public_pressed)
	$Leave.pressed.connect(_on_leave_pressed)
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):
	# Show FBI or Police or Public or Cultist or Nothing
	if(room_name == this_room):
		if(!GameManager.inventory[GameManager.ItemIDs.FLYER]):
			GameManager.obtain_item(GameManager.ItemIDs.FLYER)
			GameManager.display_dialog(GameManager.events["mansion"])
		elif(GameManager.knows_info(GameManager.InfoIDs.FBI)):
			cult.texture = load("res://assets/Scenes/5a mansiond.jpg")
			$Tunnel.show()
			GameManager.display_dialog(GameManager.events["fbi"])
			$Public.hide()
			$Cultist.hide()
		elif(GameManager.knows_info(GameManager.InfoIDs.PUBLIC)):
			cult.texture = load("res://assets/Scenes/5a mansionc.jpg")
			$Tunnel.show()
			$Tunnels.show()
			$Public.show()
			GameManager.display_dialog(GameManager.events["public"])
			$Cultist.hide()
		elif(GameManager.knows_info(GameManager.InfoIDs.TUNNEL) and 
			(GameManager.has_item(GameManager.ItemIDs.LADDER) or 
			GameManager.has_item(GameManager.ItemIDs.ROPE)) and
			(GameManager.has_item(GameManager.ItemIDs.DAGGER) or 
			GameManager.has_item(GameManager.ItemIDs.ROBE))):
			cult.texture = load("res://assets/Scenes/5a mansionb.jpg")
			$Tunnel.show()
			$Tunnels.show()
			$Balcony.show()
			$Door.show()
			$Cultist.hide()

func _on_tunnel_pressed():
	if(GameManager.knows_info(GameManager.InfoIDs.TUNNEL)):
		await GameManager.display_dialog(GameManager.events["tunnels"])
		await get_tree().process_frame
		await GameManager.change_room("Rotunda")
func _on_door_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.ROBE]):
		await GameManager.display_dialog(GameManager.events["has-robe"])
		await get_tree().process_frame
		GameManager.change_room("Rotunda")
	elif(GameManager.inventory[GameManager.ItemIDs.DAGGER]):
		await GameManager.display_dialog(GameManager.events["knife"])
		await get_tree().process_frame
		GameManager.change_room("Rotunda")
	else:
		GameManager.display_dialog(GameManager.events["need-key"])
func _on_public_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.BULLHORN]):
		GameManager.learn_info(GameManager.InfoIDs.SMASH)
		await GameManager.display_dialog(GameManager.events["has-bullhorn"])
		await get_tree().process_frame
		GameManager.change_room("Rotunda")
func _on_balcony_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.LADDER]):
		await GameManager.display_dialog(GameManager.events["has-ladder"])
		await get_tree().process_frame
		GameManager.change_room("Rotunda")
	elif(GameManager.inventory[GameManager.ItemIDs.ROPE]):
		await GameManager.display_dialog(GameManager.events["has-rope"])
		await get_tree().process_frame
		GameManager.change_room("Rotunda")
	else:
		GameManager.display_dialog(GameManager.events["balcony"])
func _on_cultist_pressed():
	if(GameManager.inventory[GameManager.ItemIDs.GUN]):
		GameManager.display_dialog(GameManager.events["cultist-scared"])
		cult.texture = load("res://assets/Scenes/5a mansionb.jpg")
		$Tunnel.show()
		$Tunnels.show()
		$Balcony.show()
		$Door.show()
		$Cultist.hide()
	else:
		GameManager.display_dialog(GameManager.events["cultist"])
	GameManager.learn_info(GameManager.InfoIDs.CULTISTS)
func _on_leave_pressed():
	GameManager.change_room("Transit")
