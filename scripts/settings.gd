#settings.gd
extends Control

var button_textures := {
	"Music": ["Music-On", "Music-Off"],
	"Sound": ["Sound-3", "Sound-2", "Sound-1", "Sound-0"],
	"Light": ["Star", "Star"],
	"Exit": ["Exit", "Exit"],
}

# Settings.gd
func _ready():
	GameManager.connect("theme_ready", _update_theme)
	Global.music_changed.connect(_update_music_ui)
	Global.sound_changed.connect(_update_sfx_ui)
	Global.theme_changed.connect(_update_theme)
	_update_music_ui()
	_update_sfx_ui()
	_update_theme(Global.dark_mode)

	# Connect button signals
	$Panel/Exit.pressed.connect(_on_exit_pressed)
	$Panel/Music.pressed.connect(_on_music_pressed)
	$Panel/Sound.pressed.connect(_on_sound_pressed)
	$Panel/Light.pressed.connect(_on_light_pressed)

func _update_music_ui():
	var volume_text := ""
	var current_volume = Global.current_volume_index
	# Create the volume string with highlighted current level
	for i in range(4):
		var volume_level = ["Off", "Low", "Med", "Full"][i]
		if i == current_volume:
			volume_text += "[%s]" % volume_level
		else:
			volume_text += volume_level
		if i < 3:  # Add separators between items
			volume_text += " / "
	$Panel/Music/Label.text = "Music: %s" % volume_text
	update_buttons(Global.dark_mode)

func _update_sfx_ui():
	var volume_text := ""
	var current_volume = Global.current_sound_index
	# Create the volume string with highlighted current level
	for i in range(4):
		var volume_level = ["Off", "Low", "Med", "Full"][i]
		if i == current_volume:
			volume_text += "[%s]" % volume_level
		else:
			volume_text += volume_level
		if i < 3:  # Add separators between items
			volume_text += " / "
	$Panel/Sound/Label.text = "Sound: %s" % volume_text
	update_buttons(Global.dark_mode)

func _update_theme(is_dark_mode: bool):
	var loc = "res://assets/UI"
	var new_theme
	if is_dark_mode:
		new_theme = "res://scenery/dark_theme.tres"
		$Panel.texture = load("%s/dark_paper.png" % [loc])
		$Panel/Music/Label.add_theme_color_override("font_color", Color(1, 1, 1))
		$Panel/Sound/Label.add_theme_color_override("font_color", Color(1, 1, 1))
		$Panel/Light/Label.add_theme_color_override("font_color", Color(1, 1, 1))
		$Panel/Light/Label.text = "Mode: [Dark] / Light"
	else:
		new_theme = "res://scenery/lite_theme.tres"
		$Panel.texture = load("%s/light_paper.png" % [loc])
		$Panel/Music/Label.add_theme_color_override("font_color", Color(0, 0, 0))
		$Panel/Sound/Label.add_theme_color_override("font_color", Color(0, 0, 0))
		$Panel/Light/Label.add_theme_color_override("font_color", Color(0, 0, 0))
		$Panel/Light/Label.text = "Mode: Dark / [Light]"
	ThemeManager.apply_theme(new_theme)
	update_buttons(is_dark_mode)

func update_buttons(is_dark_mode):
	var loc = "res://assets/UI"
	var theme_folder = "Square-Dark-" if is_dark_mode else "Square-Light-"
	for button_name in button_textures:
		var button = $Panel.get_node(button_name)
		if button:
			var which = 0
			var textures = button_textures[button_name]
			if button_name == "Music" && Global.silenced:
				which = 1
			if button_name == "Sound" && Global.muted:
				which = 3
			elif button_name == "Sound" && Global.current_sound_index>0:
				which = abs(Global.current_sound_index - 3)
			button.texture_normal = load("%s/%sDefault/%s@4x.png" % [loc, theme_folder, textures[which]])
			button.texture_hover = load("%s/%sHover/%s@4x.png" % [loc, theme_folder, textures[which]])
			button.texture_pressed = button.texture_hover

func _on_exit_pressed():
	self.visible = false

func _on_music_pressed():
	Global.toggle_music()  # Let Global handle the logic and emit signals

func _on_sound_pressed():
	Global.toggle_sound()  # Let Global handle the logic and emit signals

func _on_light_pressed():
	Global.toggle_theme()  # Let Global handle the logic and emit signals
