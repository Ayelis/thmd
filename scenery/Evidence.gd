# Evidence.gd
extends TextureRect

func _ready():
	print("Evidence area ready!")
	$Paperwork.pressed.connect(_on_papers_pressed)
	$Drawers.pressed.connect(_on_drawer_pressed)
	$Chair.pressed.connect(_on_chair_pressed)
	$Window.pressed.connect(_on_window_pressed)
func _on_papers_pressed():
	print("Papers checked!")
	GameManager.learn_info(GameManager.InfoIDs.MANSION)
	GameManager.learn_info(GameManager.InfoIDs.TUNNEL)
	GameManager.display_dialog(GameManager.events["paperwork"])
	$Paperwork.hide()
func _on_drawer_pressed():
	print("Drawer searched!")
	GameManager.obtain_item(GameManager.ItemIDs.GUN)
	GameManager.display_dialog(GameManager.events["drawers"])
	$Drawers.hide()
func _on_window_pressed():
	print("Window peeked!")
	GameManager.display_dialog(GameManager.events["window"])
	$Window.hide()
func _on_chair_pressed():
	print("Chair Left!")
	GameManager.change_room("Transit")
