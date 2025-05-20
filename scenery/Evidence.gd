# Evidence.gd
extends TextureRect

func _ready():
	$Paperwork.pressed.connect(_on_papers_pressed)
	$Drawers.pressed.connect(_on_drawer_pressed)
	$Chair.pressed.connect(_on_chair_pressed)
	$Window.pressed.connect(_on_window_pressed)
	$Leave.pressed.connect(_on_leave_pressed)
func _on_papers_pressed():
	GameManager.learn_info(GameManager.InfoIDs.MANSION)
	GameManager.learn_info(GameManager.InfoIDs.TUNNEL)
	GameManager.display_dialog(GameManager.events["paperwork"])
	$Paperwork.hide()
func _on_drawer_pressed():
	GameManager.obtain_item(GameManager.ItemIDs.GUN)
	GameManager.initiate_dialogue("evidence-drawers")
	$Drawers.hide()
func _on_window_pressed():
	GameManager.display_dialog(GameManager.events["window"])
	$Window.hide()
func _on_chair_pressed():
	GameManager.change_room("Transit")
func _on_leave_pressed():
	GameManager.change_room("Transit")
