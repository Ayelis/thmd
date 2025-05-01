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
	GameManager.display_dialog(GameManager.get_room_description("EVIDENCE"))
	$Paperwork.disabled = true
func _on_drawer_pressed():
	print("Drawer searched!")
	GameManager.obtain_item(GameManager.ItemIDs.GUN)
	GameManager.obtain_item(GameManager.ItemIDs.KEY)
	GameManager.display_dialog(GameManager.get_room_description("EVIDENCE"))
	$Drawers.disabled = true
func _on_window_pressed():
	print("Window peeked!")
	GameManager.display_dialog(GameManager.get_room_description("EVIDENCE"))
	$Window.disabled = true
func _on_chair_pressed():
	print("Chair Left!")
	GameManager.display_dialog(GameManager.get_room_description("EVIDENCE"))
	GameManager.change_room("Transit")
