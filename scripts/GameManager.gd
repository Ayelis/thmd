# GameManager.gd
extends Node

var texts = load_json("res://data/texts.json")

# Player stats
var morality := 0
var tact := 0
var ideology := 0
var sanity := 100

# Game state
signal room_changed(room_name)  # Emit both internal ID and display name
signal inventory_updated(item_id)
signal knowledge_updated(info_id)
var current_room := "home"
var pail_placed := false
var rope_placed := false
var detective_gone := false
var cultist_gone := false
var cultist_unconscious := false
var fan_text = texts["insanity"]["ceiling_fan"]

enum ItemIDs { TRANSPASS, LIBCARD, LETTER, DAGGER, ROBE, ROPE, PAIL, BULLHORN, KEY, FLYER, DETECTOR, COMBINATION, BLUEPRINTS, GUN }
var ITEMS := {}
var INFORMATION := {}

# Runtime inventory state (track obtained items here)
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
	ItemIDs.COMBINATION: false,
	ItemIDs.BLUEPRINTS: false,
	ItemIDs.GUN: false
}

enum InfoIDs { APPOINTMENT, SHACK, MANSION, CULTISTS }

# Runtime knowledge tracking
var discovered_info := {}

# Room configurations
var rooms := {
	"Home": {
		"display": texts["rooms"]["HOME"]["name"],
		"music":preload("res://assets/audio/267_Court_of_the_Count.ogg"),
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
	for item_name in texts["items"].keys():
		# Convert string name to enum value
		var item_id = ItemIDs.get(item_name)
		if item_id != null:  # Only process valid items
			ITEMS[item_id] = {
				"name": texts["items"][item_name]["name"],
				"description": texts["items"][item_name]["description"],
				"texture": _get_item_texture(item_id),  # Pass the string name
				"obtained": false
			}

	for info_id in InfoIDs.values():
		INFORMATION[info_id] = {
			"name": texts["info"][InfoIDs.keys()[info_id]]["title"],
			"description": texts["info"][InfoIDs.keys()[info_id]]["description"],
		}

func _get_item_texture(item_id: int) -> Texture2D:
	var path := "res://assets/icons/%s.png" % ItemIDs.keys()[item_id].to_lower()
	return load(path) if ResourceLoader.exists(path) else null

# Helper: Load JSON (Godot 4.x)
func load_json(path: String) -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string(path))

# Remove request_room_change() - redundant if we standardize
func change_room(new_room: String):
	current_room = new_room
	room_changed.emit(new_room)
	print("Room changed to: ", new_room)

# Set/get discovery flags
func learn_info(info_id: InfoIDs) -> void:
	discovered_info[info_id] = true
	knowledge_updated.emit(info_id)
func knows_info(info_id: InfoIDs) -> bool:
	return discovered_info.get(info_id, false)

func get_info_details(info_id: InfoIDs) -> Dictionary:
	var info = INFORMATION.get(info_id, {}).duplicate()
	info["known"] = knows_info(info_id)
	return info

# Add/remove items
func obtain_item(item_id: ItemIDs) -> void:
	inventory[item_id] = true
	inventory_updated.emit(item_id)  # Emit when items change
	print("Got: ",GameManager.ITEMS[item_id].name)
func lose_item(item_id: ItemIDs) -> void:
	inventory[item_id] = false
	print("Lost: ",GameManager.ITEMS[item_id].name)

# Check items
func has_item(item_id: ItemIDs) -> bool:
	print("Checking: ",GameManager.ITEMS[item_id].name)
	return inventory.get(item_id, false)
