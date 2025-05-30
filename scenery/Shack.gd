# Shack.gd
extends TextureRect
var this_room = "Shack"
var here_before

func _ready():
	$Ladder.pressed.connect(_on_ladder_pressed)
	$Door.pressed.connect(_on_door_pressed)
	$Drawers.pressed.connect(_on_drawers_pressed)
	$EmptyDrawers.pressed.connect(_on_emptydrawers_pressed)
	$Desk.pressed.connect(_on_desk_pressed)
	$Walls.pressed.connect(_on_walls_pressed)
	$Ceiling.pressed.connect(_on_ceiling_pressed)
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):
	if(room_name == this_room && !here_before):
		GameManager.display_dialog(GameManager.events["shack1"])
		here_before = true

func _on_desk_pressed():
	GameManager.learn_info(GameManager.InfoIDs.MANSION)
	GameManager.display_dialog(GameManager.events["shack-desk"])
	$Desk.hide()
func _on_walls_pressed():
	GameManager.display_dialog(GameManager.events["shack3"])
	$Walls.hide()
func _on_drawers_pressed():
	GameManager.display_dialog(GameManager.events["shack-drawers"])
	GameManager.obtain_item(GameManager.ItemIDs.ROPE)
	var attic = get_parent().get_node("Attic")
	attic.get_node("Rope").hide()
	attic.texture = load("res://assets/Scenes/1b atticb.jpg")
	$Drawers.hide()
func _on_emptydrawers_pressed():
	GameManager.display_dialog(GameManager.events["shack-empty"])
	$EmptyDrawers.hide()
func _on_ceiling_pressed():
	GameManager.insane(GameManager.insanity["ceiling"])
	$Ceiling.hide()
func _on_ladder_pressed():
	GameManager.obtain_item(GameManager.ItemIDs.LADDER)
	GameManager.display_dialog(GameManager.events["get-ladder"])
	texture = load("res://assets/Scenes/4b shackb.jpg")
	$Ladder.hide()
func _on_door_pressed():
	var beach = get_parent().get_node("Beach")
	beach.get_node("CloseBird").hide()
	beach.get_node("GroundBirds").hide()
	beach.get_node("FlyingBirds").hide()
	beach.texture = load("res://assets/Scenes/4a beachc.jpg")
	GameManager.change_room("Beach")
	if(!GameManager.knows_info(GameManager.InfoIDs.COMBO)):
		GameManager.display_dialog(GameManager.events["dog"])
