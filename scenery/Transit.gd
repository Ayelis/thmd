# Transit.gd
extends TextureRect

@onready var Library: Button = $LibButton
@onready var Police: Button = $PolButton
@onready var Police2: Button = $PolButton2
@onready var Beach: Button = $BeaButton
@onready var Mansion: Button = $ManButton

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
	# Initial update
	_update_button_visibility()
	print("Transit area ready!")

func _on_tracks_pressed():
	print("Tracks pondered!")
	GameManager.display_dialog(GameManager.insanity["tracks"])
	GameManager.increase_insanity()
	$Tracks.disabled = true

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
	Library.visible = GameManager.has_item(GameManager.ItemIDs.TRANSPASS)
	Police.visible = GameManager.has_item(GameManager.ItemIDs.TRANSPASS) && !GameManager.knows_info(GameManager.InfoIDs.APPOINTMENT)
	Police2.visible = GameManager.knows_info(GameManager.InfoIDs.APPOINTMENT)
	Beach.visible = GameManager.knows_info(GameManager.InfoIDs.SHACK)
	Mansion.visible = GameManager.knows_info(GameManager.InfoIDs.MANSION)

func _on_home_pressed():
	GameManager.change_room("Home")

func _on_lib_pressed():
	GameManager.change_room("Library")

func _on_police_pressed():
	GameManager.display_dialog(GameManager.events["police"])

func _on_police2_pressed():
	GameManager.change_room("Police")

func _on_beach_pressed():
	GameManager.change_room("Beach")

func _on_mansion_pressed():
	GameManager.change_room("Mansion")
