extends Control

@onready var scenery := $Rooms
@onready var rooms = $Rooms  # Your actual path to rooms container
@onready var sfx_ui = $SFX_UI

func _ready():
	var dialogue = get_node("../Dialogue") # Adjust path as needed
	dialogue.connect("dialogue_opened", Callable(self, "_on_dialogue_opened"))
	dialogue.connect("dialogue_closed", Callable(self, "_on_dialogue_closed"))
	GameManager.room_changed.connect(_on_room_changed)
	# Initialize UI
	update_ui()
	connect_buttons()
	# Load initial room
	GameManager.change_room("Home")

func _on_dialogue_opened():
	$NavBar/Buttons/Nav.visible = false
	$NavBar/Buttons/NavDisable.visible = true

func _on_dialogue_closed():
	$NavBar/Buttons/Nav.visible = true
	$NavBar/Buttons/NavDisable.visible = false

func _on_room_changed(room_name: String):
	# Hide all rooms first
	for room in $Rooms.get_children():
		room.visible = false
	# Show target room and update UI
	$Rooms.get_node(room_name).visible = true
	$TopBar/Scene.text = resolve_text_reference(GameManager.rooms[room_name].display)
	GameManager.current_room = room_name
	AudioManager.play_music(load("res://assets/audio/"+GameManager.rooms[room_name].music+".ogg"))

func resolve_text_reference(ref: String) -> String:
	var path = ref.split(".")
	var current = GameManager.texts
	current = current["rooms"]
	#path.remove_at(0)  # Remove "rooms" from path
	# Now navigate the remaining path
	for key in path:
		if current is Dictionary and current.has(key):
			current = current[key]
		else:
			push_error("Missing text reference: %s at key %s" % [ref, key])
			return "MISSING_TEXT"
	return str(current)  # Ensure we return a String

func update_ui():
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)  # Apply current theme on load

func connect_buttons():
	$NavBar/Buttons/Inv.pressed.connect(_on_inventory_pressed)
	$NavBar/Buttons/Nav.pressed.connect(_on_navigation_pressed)
	$NavBar/Buttons/Inf.pressed.connect(_on_info_pressed)
	$NavBar/Buttons/Set.pressed.connect(_on_settings_pressed)

func _on_navigation_pressed():
	if GameManager.current_room == "Transit":
		GameManager.change_room("Home")
	else:
		GameManager.change_room("Transit")

func _on_inventory_pressed():
	sfx_ui.play()
	var node = get_parent().get_node("Inventory")  # Relative path
	if node:
		node.visible = !node.visible  # Toggle visibility

func _on_info_pressed():
	sfx_ui.play()
	var node = get_parent().get_node("Info")  # Relative path
	if node:
		node.visible = !node.visible  # Toggle visibility

func _on_settings_pressed():
	sfx_ui.play()
	var node = get_parent().get_node("Settings")  # Relative path
	if node:
		node.visible = !node.visible  # Toggle visibility

func _update_theme(is_dark_mode: bool):
	var loc = "res://assets/UI"
	var theme_folder = "Rect-Dark-" if is_dark_mode else "Rect-Light-"
	var button_textures := {
		"Inv": ["Backpack"],
		"Nav": ["Nav"],
		"Inf": ["Info"],
		"Set": ["Gear"],
	}

	if is_dark_mode:
		$TopBar.color = Color(0,0,0)
		$NavBar.color = Color(0,0,0)
		$TopBar/Scene.add_theme_color_override("font_color", Color(1, 1, 1))
	else:
		$TopBar.color = Color(1,1,1)
		$NavBar.color = Color(1,1,1)
		$TopBar/Scene.add_theme_color_override("font_color", Color(0,0,0))
	for button_name in button_textures:
		var button = $NavBar/Buttons.get_node(button_name)
		if button:
			var textures = button_textures[button_name]
			button.texture_normal = load("%s/%sDefault/%s@4x.png" % [loc, theme_folder, textures[0]])
			button.texture_hover = load("%s/%sHover/%s@4x.png" % [loc, theme_folder, textures[0]])
			button.texture_pressed = button.texture_hover
func resetUI():
	$UI/Rooms/Home.texture = load("res://assets/Scenes/1a home.jpg")
	$UI/Rooms/Transit.texture = load("res://assets/Scenes/2a transit.jpg")
	$UI/Rooms/Police.texture = load("res://assets/Scenes/3a police.jpg")
	$UI/Rooms/Beach.texture = load("res://assets/Scenes/4a beach.jpg")
	$UI/Rooms/Mansion.texture = load("res://assets/Scenes/5a mansion.jpg")
	$UI/Rooms/Attic.texture = load("res://assets/Scenes/1b attic.jpg")
	$UI/Rooms/Library.texture = load("res://assets/Scenes/2b library.jpg")
	$UI/Rooms/Evidence.texture = load("res://assets/Scenes/3b evidence.jpg")
	$UI/Rooms/Shack.texture = load("res://assets/Scenes/4b shack.jpg")
	$UI/Rooms/Rotunda.texture = load("res://assets/Scenes/5b rotunda.jpg")
