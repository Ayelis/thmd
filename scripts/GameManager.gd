extends Node

@warning_ignore("unused_signal")

@onready var scene_root = self

# Player stats
var morality := 0
var tact := 0
var ideology := 0
var baseSanity := 5
var sanity := baseSanity
var returned_home := false

# Signals
signal room_changed(room_name)
signal inventory_updated(item_id)
signal inventory_full_refresh()
signal knowledge_updated(info_id)
signal info_full_refresh()
signal dialog_updated(text)
signal ending_updated(texture_path, text_key)
signal dialogue_closed

# Game state
var current_room := "home"

# Items
enum ItemIDs { 
	TRANSPASS, LIBCARD, LETTER, DAGGER, ROBE, ROPE, LADDER, 
	BULLHORN, KEY, FLYER, DETECTOR, GUN 
}
var texts := {}
var ITEMS := {}
var inventory := {
	ItemIDs.TRANSPASS: false,
	ItemIDs.LIBCARD: false,
	ItemIDs.LETTER: false,
	ItemIDs.DAGGER: false, 
	ItemIDs.ROBE: false,
	ItemIDs.ROPE: false,
	ItemIDs.LADDER: false,
	ItemIDs.BULLHORN: false,
	ItemIDs.KEY: false,
	ItemIDs.FLYER: false,
	ItemIDs.DETECTOR: false,
	ItemIDs.GUN: false
}

# Knowledge
enum InfoIDs { NOINFO, DAUGHTER, APPOINTMENT, SHACK, MANSION, CULTISTS, POLICE, TUNNEL, COMBO, FAMILY,
				ABDUCTOR, DOGGO, FBI, PUBLIC }
var INFORMATION := {}
var discovered_info := {}
var events := {}
var insanity := {}
var endings := {}
var dialogs := {}
var rooms := {}

func apply_theme_to_buttons(theme: Theme):
	for button in get_tree().get_nodes_in_group("ui_button"):
		button.theme = theme
		button.theme_type_variation = "StyledButton"  # If using variations

func _ready():
	texts = load_json("res://data/texts.json")
	rooms = load_json("res://data/rooms.json")
	DialogueManager.load_dialogs(texts)  # Pass to DialogueManager
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
	learn_info(InfoIDs["NOINFO"])
	events = texts["events"]  # Auto-connect your JSON events
	insanity = texts["insanity"]  # Auto-connect your JSON insanity
	endings = texts["endings"]  # Auto-connect your JSON endings
	dialogs = texts["dialogs"]  # Auto-connect your JSON dialogs

func _get_item_texture(item_id: int) -> Texture2D:
	var path := "res://assets/icons/%s.png" % ItemIDs.keys()[item_id].to_lower()
	return load(path) if ResourceLoader.exists(path) else null

func load_json(path: String) -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string(path))

func display_dialog(text: String):
	dialog_updated.emit(text) #Simple Messages

func initiate_dialogue(dialog_id: String, on_complete: Callable = Callable()):
	DialogueManager.start_structured(dialog_id, on_complete) #Structured Dialogues

func on_theme_ready(new_theme):
	$CanvasLayer.theme = new_theme

func ending(text_key: String, title_name: String = "Insanity", texture_path: String = "padded", timbre: String = "67_Asylum"):
	ending_updated.emit(text_key, title_name, texture_path, timbre)
	# Create fullscreen TextureRect if it doesn't exist

func change_room(new_room: String):
	current_room = new_room
	room_changed.emit(new_room)

func learn_info(info_id: InfoIDs) -> void:
	if(knows_info(InfoIDs["NOINFO"])):
		forget_info(InfoIDs["NOINFO"])
	discovered_info[info_id] = true
	knowledge_updated.emit(info_id)
	info_full_refresh.emit()

func knows_info(info_id: InfoIDs) -> bool:
	return discovered_info.get(info_id, false)

func forget_info(info_id: InfoIDs) -> void:
	discovered_info[info_id] = false
	knowledge_updated.emit(info_id)
	info_full_refresh.emit()

func get_info_details(info_id: InfoIDs) -> Dictionary:
	var info = INFORMATION.get(info_id, {}).duplicate()
	info["known"] = knows_info(info_id)
	return info

func obtain_item(item_id: ItemIDs) -> void:
	inventory[item_id] = true
	inventory_updated.emit(item_id)
	inventory_full_refresh.emit()

func lose_item(item_id: ItemIDs) -> void:
	inventory[item_id] = false
	inventory_full_refresh.emit()

func has_item(item_id: ItemIDs) -> bool:
	return inventory.get(item_id, false)

func get_room_description(room_key: String) -> String:
	return rooms.get(room_key, {}).get("description1", "No description available")

func insane(sanity_key: String):
	GameManager.display_dialog(sanity_key)
	GameManager.increase_insanity()
	await self.dialogue_closed
	if(sanity < 1):
		ending("sanity")

func increase_insanity():
	sanity=sanity-1

func restore_sanity():
	sanity=5

#func hard_reset():
	## Clear all persistent state
	#get_tree().paused = false
	## Full engine restart
	## 1. Delete everything
	#get_tree().root.propagate_call("queue_free")
	## 2. Reload main scene (adjust path)
	#var err = get_tree().change_scene_to_file("res://TitleScreen.tscn")
	#if err != OK:
		#get_tree().quit()
