#Global.gd
extends Node

var dark_mode := true  # Default: Dark Mode
signal reset_game

var music_volume_levels := [-80.0, -25.0, -10.0, 0.0]  # Mute, 33%, 66%, 100%
var current_volume_index := 3  # Start at 100% volume
var current_sound_index := 3  # Start at 100% volume
var sound_volume_levels := [-80.0, -25.0, -10.0, 0.0]  # Mute, 33%, 66%, 100%
var silenced := false  # Default: Music stopped
var muted := false  # Default: Sound stopped

signal music_changed()
signal sound_changed()
signal theme_changed(is_dark_mode: bool)

func toggle_music():
	if silenced:
		# If currently silenced, unmute at last volume level
		silenced = false
		AudioServer.set_bus_mute(AudioManager.MUS_BUS_ID, false)
		current_volume_index = (current_volume_index + 1) % music_volume_levels.size()
		AudioServer.set_bus_volume_db(AudioManager.MUS_BUS_ID, music_volume_levels[current_volume_index])
	else:
		# Cycle through volume levels
		current_volume_index = (current_volume_index + 1) % music_volume_levels.size()
		if current_volume_index == 0:
			# If we reached mute level, set muted flag
			silenced = true
			AudioServer.set_bus_mute(AudioManager.MUS_BUS_ID, true)
		else:
			AudioServer.set_bus_volume_db(AudioManager.MUS_BUS_ID, music_volume_levels[current_volume_index])
	music_changed.emit()

func toggle_sound():
	if muted:
		# If currently muted, unmute at last volume level
		muted = false
		AudioServer.set_bus_mute(AudioManager.SFX_BUS_ID, false)
		current_sound_index = (current_sound_index + 1) % sound_volume_levels.size()
		AudioServer.set_bus_volume_db(AudioManager.SFX_BUS_ID, sound_volume_levels[current_sound_index])
	else:
		# Cycle through volume levels
		current_sound_index = (current_sound_index + 1) % sound_volume_levels.size()
		if current_sound_index == 0:
			# If we reached mute level, set muted flag
			muted = true
			AudioServer.set_bus_mute(AudioManager.SFX_BUS_ID, true)
		else:
			AudioServer.set_bus_volume_db(AudioManager.SFX_BUS_ID, sound_volume_levels[current_sound_index])
	sound_changed.emit()

func toggle_theme():
	dark_mode = !dark_mode
	emit_signal("theme_changed", dark_mode)  # Emit signal with new state

func reset():
	emit_signal("reset_game")
