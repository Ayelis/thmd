# Evidence.gd
extends TextureRect
var this_room = "Evidence"
var here_before

func _ready():
	$Paperwork.pressed.connect(_on_papers_pressed)
	$Drawers.pressed.connect(_on_drawer_pressed)
	$Chair.pressed.connect(_on_chair_pressed)
	$Window.pressed.connect(_on_window_pressed)
	$Leave.pressed.connect(_on_leave_pressed)
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):
	if(room_name == this_room && !here_before):
		GameManager.display_dialog(GameManager.events["evidence"])
		here_before = true
func _on_papers_pressed():
	GameManager.learn_info(GameManager.InfoIDs.TUNNEL)
	GameManager.display_dialog(GameManager.events["paperwork"])
	$Paperwork.hide()
func _on_drawer_pressed():
	if(!GameManager.has_item(GameManager.ItemIDs.GUN)):
		GameManager.initiate_dialogue("evidence-drawers")
func _on_window_pressed():
	GameManager.display_dialog(GameManager.events["window"])
	$Window.hide()
func _on_chair_pressed():
	GameManager.change_room("Police")
func _on_leave_pressed():
	GameManager.change_room("Police")
