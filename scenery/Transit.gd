# Transit.gd
extends TextureRect

func _ready():
	# Check signals
	GameManager.inventory_updated.connect(_on_inventory_updated)
	GameManager.knowledge_updated.connect(_on_knowledge_updated)
	# Track buttons
	$HomButton.pressed.connect(_on_home_pressed)
	$LibButton.pressed.connect(_on_lib_pressed)
	$PolButton.pressed.connect(_on_police_pressed)
	$PolButton2.pressed.connect(_on_police2_pressed)
	$BeaButton.pressed.connect(_on_beach_pressed)
	$ManButton.pressed.connect(_on_mansion_pressed)
	$Tracks.pressed.connect(_on_tracks_pressed)
	$Board.pressed.connect(_on_board_pressed)
	# Initial update
	_update_button_visibility()
	print("Transit area ready!")

func _on_tracks_pressed():
	print("Tracks pondered!")
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
	$PolButton.visible = GameManager.has_item(GameManager.ItemIDs.TRANSPASS) && !GameManager.knows_info(GameManager.InfoIDs.APPOINTMENT)
	$PolButton2.visible = GameManager.knows_info(GameManager.InfoIDs.APPOINTMENT)
	$BeaButton.visible = GameManager.knows_info(GameManager.InfoIDs.SHACK)
	$ManButton.visible = GameManager.knows_info(GameManager.InfoIDs.MANSION)

func _on_home_pressed():
	GameManager.change_room("Home")
	if(!GameManager.returned_home):
		GameManager.returned_home = true
		GameManager.display_dialog(GameManager.events["home2"])

func _on_lib_pressed():
	GameManager.change_room("Library")
	if(!GameManager.inventory[GameManager.ItemIDs.LIBCARD]):
		GameManager.obtain_item(GameManager.ItemIDs.LIBCARD)
		GameManager.display_dialog(GameManager.events["library"])
	else:
		GameManager.display_dialog(GameManager.events["library2"])

func _on_police_pressed():
	GameManager.change_room("Police")
	GameManager.connect("dialogue_closed", self._on_police_dialog_finished, CONNECT_ONE_SHOT)
	GameManager.display_dialog(GameManager.events["police"])
func _on_police_dialog_finished():
	GameManager.change_room("Transit")

func _on_police2_pressed():
	if GameManager.knows_info(GameManager.InfoIDs.POLICE):
		GameManager.change_room("Police2")
		var police = get_parent().get_node("Police2")
		police.texture = load("res://assets/Scenes/3a policeb.jpg")
		police.get_node("Papers").pressed.connect(police._on_papers_pressed)
		police.get_node("Drawers").pressed.connect(police._on_drawers_pressed)
		GameManager.display_dialog(GameManager.events["police3"])
	else:
		GameManager.change_room("Police2")
		GameManager.display_dialog(GameManager.events["police2"])

func _on_beach_pressed():
	GameManager.change_room("Beach")
	GameManager.display_dialog(GameManager.events["beach"])

func _on_board_pressed():
	if(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS]):
		GameManager.display_dialog(GameManager.events["nopass"])

func _on_mansion_pressed():
	GameManager.change_room("Mansion")
	if(!GameManager.inventory[GameManager.ItemIDs.FLYER]):
		GameManager.obtain_item(GameManager.ItemIDs.FLYER)
		GameManager.display_dialog(GameManager.events["mansion"])
	else:
		var cult = get_parent().get_node("Mansion")
		cult.texture = load("res://assets/Scenes/5a mansionb.jpg")
		cult.get_node("Tunnel").pressed.connect(cult._on_tunnel_pressed)
		cult.get_node("Tunnels").pressed.connect(cult._on_tunnel_pressed)
		cult.get_node("Balcony").pressed.connect(cult._on_balcony_pressed)
		cult.get_node("Door").pressed.connect(cult._on_door_pressed)
		cult.get_node("Cultist").hide()
