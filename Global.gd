#Global.gd
extends Node

var silenced := false  # Default: Music stopped
var muted := false  # Default: Sound stopped
var dark_mode := true  # Default: Dark Mode

func toggle_music():
	silenced = !silenced
	emit_signal("music_changed", silenced)

func toggle_sound():
	muted = !muted
	emit_signal("sound_changed", muted)

func toggle_theme():
	dark_mode = !dark_mode
	emit_signal("theme_changed", dark_mode)  # Emit signal with new state

signal music_changed(is_silenced)
signal sound_changed(is_muted)
signal theme_changed(is_dark_mode)
