# Police.gd
extends TextureRect

func _ready():
	print("Police area ready!")
	$Detective.pressed.connect(_on_detective_pressed)
	$Computer.pressed.connect(_on_computer_pressed)
	$Papers.pressed.connect(_on_papers_pressed)
	$Drawers.pressed.connect(_on_drawers_pressed)
func _on_computer_pressed():
	print("Computer!")
	GameManager.display_dialog(GameManager.get_room_description("POLICE"))
func _on_drawers_pressed():
	print("Drawers!")
	GameManager.obtain_item(GameManager.ItemIDs.BULLHORN)
	GameManager.display_dialog(GameManager.get_room_description("POLICE"))
func _on_papers_pressed():
	print("Papers!")
	GameManager.display_dialog(GameManager.get_room_description("POLICE"))
func _on_detective_pressed():
	print("Detective!")
	GameManager.display_dialog(GameManager.get_room_description("POLICE"))
	texture = load("res://assets/Scenes/3a policeb.jpg")
	GameManager.learn_info(GameManager.InfoIDs.POLICE)
