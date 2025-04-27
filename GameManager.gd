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
var inventory := []
var discovered_info := {}

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
