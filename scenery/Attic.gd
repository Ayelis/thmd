# Attic.gd
extends TextureRect
var this_room = "Attic"
var here_before

func _ready():
	$Rope.pressed.connect(_on_rope_pressed)
	$Drawers.pressed.connect(_on_drawers_pressed)
	$Window.pressed.connect(_on_window_pressed)
	$Vines.pressed.connect(_on_vines_pressed)
	$Leave.pressed.connect(_on_leave_pressed)
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):
	if(room_name == this_room && !here_before):
		GameManager.display_dialog(GameManager.events["attic"])
		here_before = true

func _on_rope_pressed():
	if(!GameManager.inventory[GameManager.ItemIDs.ROPE]):
		GameManager.obtain_item(GameManager.ItemIDs.ROPE)
		GameManager.display_dialog(GameManager.events["get-rope"])
		$Rope.hide()
		var shack = get_parent().get_node("Shack")
		shack.get_node("Drawers").hide()
		shack.get_node("EmptyDrawers").show()
		texture = load("res://assets/Scenes/1b atticb.jpg")

func _on_drawers_pressed():
	if(!GameManager.inventory[GameManager.ItemIDs.ROBE]):
		GameManager.display_dialog("get-robe")
		$Drawers.hide()

func _on_window_pressed():
	GameManager.display_dialog(GameManager.events["windowgaze"])
	$Window.hide()

func _on_vines_pressed():
	GameManager.insane(GameManager.insanity["vines"])
	$Vines.hide()

func _on_leave_pressed():
	GameManager.change_room("Home")
