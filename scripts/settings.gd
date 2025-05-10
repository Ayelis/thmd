#settings.gd
extends Control

var button_textures := {
	"Music": ["Music-On", "Music-Off"],
	"Sound": ["Sound-3", "Sound-0"],
	"Light": ["Star", "Star"],
	"Exit": ["Exit", "Exit"],
}

# Settings.gd
func _ready():
	GameManager.connect("theme_ready", _update_theme)

	Global.audio_player = $AudioStreamPlayer2D
	print("Player assigned: ", Global.audio_player != null)  # Must print TRUE
	Global.music_changed.connect(_update_music_ui)
	Global.sound_changed.connect(_update_sfx_ui)
	Global.theme_changed.connect(_update_theme)
	_update_music_ui(Global.silenced)
	_update_sfx_ui(Global.muted)
	_update_theme(Global.dark_mode)

	# Connect button signals
	$Panel/Exit.pressed.connect(_on_exit_pressed)
	$Panel/Music.pressed.connect(_on_music_pressed)
	$Panel/Sound.pressed.connect(_on_sound_pressed)
	$Panel/Light.pressed.connect(_on_light_pressed)

func _update_music_ui(is_silenced: bool):
	$Panel/Music/Label.text = "Music: %s" % ("On / [Off]" if is_silenced else "[On] / Off")
	update_buttons(Global.dark_mode)

func _update_sfx_ui(is_muted: bool):
	$Panel/Sound/Label.text = "Sound: %s" % ("On / [Off]" if is_muted else "[On] / Off")
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
				which = 1
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
