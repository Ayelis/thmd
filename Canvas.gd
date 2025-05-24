# Canvas.gd (Attached to Root control node)
extends Control

@onready var dlg = $CanvasLayer/Dialogue

func _ready():
	Global.connect("reset_game", _on_game_reset)
	DialogueManager.set_dialogue_node(dlg)
	Aspect.scale_updated.connect(_on_scale_updated)
	_on_scale_updated(Aspect.scale_factor, get_viewport().get_visible_rect().size)

func _on_scale_updated(scale_size: float, viewport_size: Vector2):
	$CanvasLayer/UI.scale = Vector2(scale_size, scale_size)
	$CanvasLayer/UI.position = (viewport_size - ($CanvasLayer/UI.size * scale)) / 2

func _on_game_reset():
	#Reset inventory and knowledge
	for i in GameManager.discovered_info:
		GameManager.forget_info(i)
	GameManager.learn_info(GameManager.InfoIDs["NOINFO"])
	for i in GameManager.inventory:
		GameManager.lose_item(i)
	#Reset stats
	GameManager.sanity = GameManager.baseSanity
	#Reset Rooms
	$CanvasLayer/UI/Rooms/Police.texture = load("res://assets/Scenes/3a police.jpg")
	$CanvasLayer/UI/Rooms/Beach.texture = load("res://assets/Scenes/4a beach.jpg")
	$CanvasLayer/UI/Rooms/Shack.texture = load("res://assets/Scenes/4b shack.jpg")
	$CanvasLayer/UI/Rooms/Mansion.texture = load("res://assets/Scenes/5a mansion.jpg")
	$CanvasLayer/UI/Rooms/Rotunda.texture = load("res://assets/Scenes/5b rotunda.jpg")
	#Reset clickable regions
	$CanvasLayer/UI/Rooms/Home/Dressers.show()
	$CanvasLayer/UI/Rooms/Home/Hall.show()
	$CanvasLayer/UI/Rooms/Home/Window.show()
	$CanvasLayer/UI/Rooms/Home/Fan.show()
	$CanvasLayer/UI/Rooms/Attic/Rope.show()
	$CanvasLayer/UI/Rooms/Attic/Drawers.show()
	$CanvasLayer/UI/Rooms/Attic/Window.show()
	$CanvasLayer/UI/Rooms/Attic/Vines.show()
	$CanvasLayer/UI/Rooms/Transit/Tracks.show()
	$CanvasLayer/UI/Rooms/Transit/LibButton.hide()
	$CanvasLayer/UI/Rooms/Transit/PolButton.hide()
	$CanvasLayer/UI/Rooms/Transit/PolButton2.hide()
	$CanvasLayer/UI/Rooms/Transit/BeaButton.hide()
	$CanvasLayer/UI/Rooms/Transit/ManButton.hide()
	$CanvasLayer/UI/Rooms/Library/Shelves.show()
	$CanvasLayer/UI/Rooms/Police2/Drawers.show()
	$CanvasLayer/UI/Rooms/Police2/Papers.show()
	$CanvasLayer/UI/Rooms/Evidence/Paperwork.show()
	$CanvasLayer/UI/Rooms/Evidence/Drawers.show()
	$CanvasLayer/UI/Rooms/Evidence/Window.show()
	$CanvasLayer/UI/Rooms/Beach/CloseBird.show()
	$CanvasLayer/UI/Rooms/Beach/GroundBirds.show()
	$CanvasLayer/UI/Rooms/Beach/FlyingBirds.show()
	$CanvasLayer/UI/Rooms/Beach/Sand.show()
	$CanvasLayer/UI/Rooms/Beach/Sky.show()
	$CanvasLayer/UI/Rooms/Beach/Ocean.show()
	$CanvasLayer/UI/Rooms/Beach/Shack.show()
	$CanvasLayer/UI/Rooms/Shack/Desk.show()
	$CanvasLayer/UI/Rooms/Shack/Walls.show()
	$CanvasLayer/UI/Rooms/Shack/Drawers.show()
	$CanvasLayer/UI/Rooms/Shack/Ceiling.show()
	$CanvasLayer/UI/Rooms/Shack/Ladder.show()
	$CanvasLayer/UI/Rooms/Mansion/Cultist.show()
	$CanvasLayer/UI/Rooms/Rotunda/Blood.show()
	$CanvasLayer/UI/Rooms/Rotunda/Circle.show()
	#Reset Player POV
	GameManager.change_room("Home")
	GameManager.display_dialog(GameManager.events["home1"])
	$CanvasLayer/Insanity.hide()
