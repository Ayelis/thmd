# Transit.gd
extends TextureRect
var this_room = "Transit"

func _ready():
	# Check signals
	GameManager.inventory_updated.connect(_on_inventory_updated)
	GameManager.knowledge_updated.connect(_on_knowledge_updated)
	# Track buttons
	$HomButton.pressed.connect(_on_home_pressed)
	$LibButton.pressed.connect(_on_lib_pressed)
	$PolButton.pressed.connect(_on_police_pressed)
	$BeaButton.pressed.connect(_on_beach_pressed)
	$ManButton.pressed.connect(_on_mansion_pressed)
	$Tracks.pressed.connect(_on_tracks_pressed)
	$Board.pressed.connect(_on_board_pressed)
	# Initial update
	_update_button_visibility()
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):
	if(room_name == this_room):
		GameManager.left_home = true
		if(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS]):
			GameManager.display_dialog(GameManager.events["nopass"])

func _on_tracks_pressed():
	GameManager.insane(GameManager.insanity["tracks"])
	$Tracks.hide()

func _on_inventory_updated(item_id):
	if item_id == GameManager.ItemIDs.TRANSPASS:
		_update_button_visibility()

func _on_knowledge_updated(info_id: GameManager.InfoIDs):
	match info_id:
		GameManager.InfoIDs.APPOINTMENT, \
		GameManager.InfoIDs.SHACK, \
		GameManager.InfoIDs.MANSION:
			_update_button_visibility()

func _update_button_visibility():
	$LibButton.visible = GameManager.has_item(GameManager.ItemIDs.TRANSPASS)
	$PolButton.visible = GameManager.has_item(GameManager.ItemIDs.TRANSPASS)
	$BeaButton.visible = GameManager.knows_info(GameManager.InfoIDs.SHACK)
	$ManButton.visible = GameManager.knows_info(GameManager.InfoIDs.MANSION)

func _on_home_pressed():
	GameManager.change_room("Home")

func _on_police_pressed():
	GameManager.change_room("Police")

func _on_lib_pressed():
	GameManager.change_room("Library")

func _on_beach_pressed():
	GameManager.change_room("Beach")

func _on_board_pressed():
	if(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS]):
		GameManager.display_dialog(GameManager.events["nopass"])

func _on_mansion_pressed():
	GameManager.change_room("Mansion")
