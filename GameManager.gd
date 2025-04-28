# GameManager.gd
extends Node

# Player stats
var morality := 0
var tact := 0
var ideology := 0
var sanity := 100

# Game state
signal room_changed(room_name, display_name)  # Emit both internal ID and display name
var current_room := "home"
var has_transit_pass := false
var has_gun := false
var has_knife := false
var has_robe := false
var has_rope := false
var has_dagger := false
var has_key := false
var has_flyer := false
var has_bullhorn := false
var has_library_card := false
var has_blueprints := false
var has_combination := false
var has_metal_detector := false
var has_appointment := false
var knows_shack := false
var knows_mansion := false
var pail_placed := false
var rope_placed := false
var detective_gone := false
var cultist_gone := false
var cultist_unconscious := false
var inventory := []
var discovered_info := {}
signal room_change_requested(room_name)  # Instead of direct node access

func request_room_change(new_room: String):
	if can_access_room(new_room):
		current_room = new_room
		room_change_requested.emit(new_room)
	else:
		print("Access denied to ", new_room)

func can_access_room(room: String) -> bool:
	match room:
		"Library": return has_transit_pass
		"Police": return has_appointment
		"Beach": return knows_shack
		"Mansion": return knows_mansion
		_: return true

# Add/remove items
func add_item(item_name: String) -> void:
	if not inventory.has(item_name):
		inventory.append(item_name)
		print("Added ", item_name, ". Inventory: ", inventory)

func remove_item(item_name: String) -> bool:
	var index = inventory.find(item_name)
	if index >= 0:
		inventory.remove_at(index)
		return true
	return false

# Set/get discovery flags
func learn_info(info_key: String, value = true) -> void:
	discovered_info[info_key] = value
	print("Learned: ", info_key, " = ", value)

func knows_info(info_key: String) -> bool:
	print("Recalling: ", info_key)
	return discovered_info.get(info_key, false)

# Room configurations
var rooms := {
	"Home": {
		"display": "My Home",
		"music":preload("res://assets/audio/267_Court_of_the_Count.mp3"),
		"texture": "res://assets/Scenes/1a_home.jpg",
		"elements": ["Door", "Desk", "Bucket"]
	},
	"Transit": {
		"display": "Lightrail Stop",
		"music":preload("res://assets/audio/330_Mega_City_Slums.mp3"),
		"texture": "res://assets/Scenes/2a_transit.jpg",
		"elements": ["PoliceButton", "LibraryButton", "BeachButton", "MansionButton"]
	},
	"Police": {
		"display": "Police Station",
		"music":preload("res://assets/audio/229_Interrogation_Room.mp3"),
		"texture": "res://assets/Scenes/3a_police.jpg",
		"elements": []
	},
	"Beach": {
		"display": "Public Beach",
		"music":preload("res://assets/audio/166_Quiet_Cove.mp3"),
		"texture": "res://assets/Scenes/4a_police.jpg",
		"elements": ["Shack", "Door", "Bird"]
	},
	"Mansion": {
		"display": "Mansion Path",
		"music":preload("res://assets/audio/359_Skull_Island.mp3"),
		"texture": "res://assets/Scenes/5a_police.jpg",
		"elements": ["Mansion"]
	},
	"Attic": {
		"display": "Musty Attic",
		"music":preload("res://assets/audio/413_Collegium_Magica.mp3"),
		"texture": "res://assets/Scenes/1b_attic.jpg",
		"elements": ["Desk", "Rope", "Window"]
	},
	"Library": {
		"display": "City Library",
		"music":preload("res://assets/audio/333_Arcane_Athenaeum.mp3"),
		"texture": "res://assets/Scenes/2b_library.jpg",
		"elements": ["Computer", "Chair"]
	},
	"Evidence": {
		"display": "Evidence Lockup",
		"music":preload("res://assets/audio/289_Ancient_Artifact.mp3"),
		"texture": "res://assets/Scenes/3b_evidence.jpg",
		"elements": ["Chair", "Board", "Desk"]
	},
	"Shack": {
		"display": "Abandoned Shack",
		"music":preload("res://assets/audio/297_Survivors_Bivouac.mp3"),
		"texture": "res://assets/Scenes/4b_shack.jpg",
		"elements": ["Desk", "Pail", "Cabinet", "Door"]
	},
	"Rotunda": {
		"display": "Rotunda Altar",
		"music":preload("res://assets/audio/320_Cultists_Cavern.mp3"),
		"texture": "res://assets/Scenes/5b_altar.jpg",
		"elements": ["Columns", "Windows", "Circle"]
	}
}

func ready():
	print("GameManager loaded!")  # Should appear when game launches

func can_access_location(location: String) -> bool:
	match location:
		"transit": return true  # Always accessible
		"police", "library", "beach": 
			return has_transit_pass
		_: return true

func change_room(new_room: String, display_name: String):
	current_room = new_room
	room_changed.emit(new_room, display_name)
