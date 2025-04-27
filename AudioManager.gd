# AudioManager.gd (autoload)
extends Node

var current_track : AudioStreamPlayer
var fade_tween : Tween

func play_music(track: AudioStream, loop: bool = true):
	if current_track and current_track.stream == track:
		return  # Already playing
	
	# Fade out old track
	if current_track:
		fade_tween = create_tween()
		fade_tween.tween_property(current_track, "volume_db", -80.0, 1.0)
		fade_tween.tween_callback(current_track.stop)
	
	# Play new track
	current_track = AudioStreamPlayer.new()
	add_child(current_track)
	current_track.stream = track
	current_track.volume_db = 0.0
	current_track.bus = "Music"
	current_track.play()
	if loop:
		current_track.finished.connect(current_track.play)
