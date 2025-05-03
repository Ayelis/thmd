extends Node

var texts = load_json("res://data/texts.json")

# Player stats
var morality := 0
var tact := 0
var ideology := 0
var sanity := 3

# Signals
signal room_changed(room_name)
signal inventory_updated(item_id)
signal inventory_full_refresh()
signal knowledge_updated(info_id)
signal info_full_refresh()
signal dialogue_updated(text)

# Game state
var current_room := "home"
var pail_placed := false
var rope_placed := false
var detective_gone := false
var cultist_gone := false
var cultist_unconscious := false

# Items
enum ItemIDs { 
	TRANSPASS, LIBCARD, LETTER, DAGGER, ROBE, ROPE, PAIL, 
	BULLHORN, KEY, FLYER, DETECTOR, GUN 
}
var ITEMS := {}
var inventory := {
	ItemIDs.TRANSPASS: false,
	ItemIDs.LIBCARD: false,
	ItemIDs.LETTER: false,
	ItemIDs.DAGGER: false, 
	ItemIDs.ROBE: false,
	ItemIDs.ROPE: false,
	ItemIDs.PAIL: false,
	ItemIDs.BULLHORN: false,
	ItemIDs.KEY: false,
	ItemIDs.FLYER: false,
	ItemIDs.DETECTOR: false,
	ItemIDs.GUN: false
}

# Knowledge
enum InfoIDs { DAUGHTER, APPOINTMENT, SHACK, MANSION, CULTISTS, POLICE, TUNNEL, COMBO, FAMILY }
var INFORMATION := {}
var discovered_info := {}
var events := {}
var insanity := {}

# Rooms
var rooms := {
	"Home": {
		"display": texts["rooms"]["HOME"]["name"],
		"music": preload("res://assets/audio/267_Court_of_the_Count.ogg"),
		"texture": "res://assets/Scenes/1a_home.jpg",
	},
	"Transit": {
		"display": texts["rooms"]["TRANSIT"]["name"],
		"music":preload("res://assets/audio/330_Mega_City_Slums.ogg"),
		"texture": "res://assets/Scenes/2a_transit.jpg",
	},
	"Police": {
		"display": texts["rooms"]["POLICE"]["name"],
		"music":preload("res://assets/audio/229_Interrogation_Room.ogg"),
		"texture": "res://assets/Scenes/3a_police.jpg",
	},
	"Beach": {
		"display": texts["rooms"]["BEACH"]["name"],
		"music":preload("res://assets/audio/166_Quiet_Cove.ogg"),
		"texture": "res://assets/Scenes/4a_police.jpg",
	},
	"Mansion": {
		"display": texts["rooms"]["MANSION"]["name"],
		"music":preload("res://assets/audio/359_Skull_Island.ogg"),
		"texture": "res://assets/Scenes/5a_police.jpg",
	},
	"Attic": {
		"display": texts["rooms"]["ATTIC"]["name"],
		"music":preload("res://assets/audio/413_Collegium_Magica.ogg"),
		"texture": "res://assets/Scenes/1b_attic.jpg",
	},
	"Library": {
		"display": texts["rooms"]["LIBRARY"]["name"],
		"music":preload("res://assets/audio/333_Arcane_Athenaeum.ogg"),
		"texture": "res://assets/Scenes/2b_library.jpg",
	},
	"Evidence": {
		"display": texts["rooms"]["EVIDENCE"]["name"],
		"music":preload("res://assets/audio/289_Ancient_Artifact.ogg"),
		"texture": "res://assets/Scenes/3b_evidence.jpg",
	},
	"Shack": {
		"display": texts["rooms"]["SHACK"]["name"],
		"music":preload("res://assets/audio/297_Survivors_Bivouac.ogg"),
		"texture": "res://assets/Scenes/4b_shack.jpg",
	},
	"Rotunda": {
		"display": texts["rooms"]["ROTUNDA"]["name"],
		"music":preload("res://assets/audio/320_Cultists_Cavern.ogg"),
		"texture": "res://assets/Scenes/5b_altar.jpg",
	}
}

func _ready():
	print("GameManager loaded!")
	
	# Load items
	for item_name in texts["items"].keys():
		var item_id = ItemIDs.get(item_name)
		if item_id != null:
			ITEMS[item_id] = {
				"name": texts["items"][item_name]["name"],
				"description": texts["items"][item_name]["description"],
				"texture": _get_item_texture(item_id),
				"obtained": false
			}

	# Initialize all info as undiscovered
	for info_id in InfoIDs.values():
		discovered_info[info_id] = false
		INFORMATION[info_id] = {
			"description": texts["info"][InfoIDs.keys()[info_id]]["description"],
		}
	events = texts["events"]  # Auto-connect your JSON events
	insanity = texts["insanity"]  # Auto-connect your JSON insanity

func _get_item_texture(item_id: int) -> Texture2D:
	var path := "res://assets/icons/%s.png" % ItemIDs.keys()[item_id].to_lower()
	return load(path) if ResourceLoader.exists(path) else null

func load_json(path: String) -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string(path))

func display_dialog(text):
	dialogue_updated.emit(text)

func change_room(new_room: String):
	current_room = new_room
	room_changed.emit(new_room)

func learn_info(info_id: InfoIDs) -> void:
	discovered_info[info_id] = true
	knowledge_updated.emit(info_id)
	info_full_refresh.emit()

func knows_info(info_id: InfoIDs) -> bool:
	return discovered_info.get(info_id, false)

func get_info_details(info_id: InfoIDs) -> Dictionary:
	var info = INFORMATION.get(info_id, {}).duplicate()
	info["known"] = knows_info(info_id)
	return info

func obtain_item(item_id: ItemIDs) -> void:
	inventory[item_id] = true
	inventory_updated.emit(item_id)
	inventory_full_refresh.emit()
	print("Got: ", ITEMS[item_id].name)

func lose_item(item_id: ItemIDs) -> void:
	inventory[item_id] = false
	inventory_full_refresh.emit()
	print("Lost: ", ITEMS[item_id].name)

func has_item(item_id: ItemIDs) -> bool:
	print("Checking: ", ITEMS[item_id].name)
	return inventory.get(item_id, false)

func get_room_description(room_key: String) -> String:
	return rooms.get(room_key, {}).get("description1", "No description available")

func insane(sanity_key: String):
	GameManager.display_dialog(sanity_key)
	GameManager.increase_insanity()

func increase_insanity():
	sanity=sanity-1

func restore_sanity():
	sanity=3

func hard_reset():
	# Clear all persistent state
	get_tree().paused = false
	Global.reset_all_variables()  # You'd need to implement this
	# Full engine restart
	get_tree().quit()
	OS.execute(OS.get_executable_path(), [])  # Restart executable
