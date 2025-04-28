extends Node

# Music
var music_player : AudioStreamPlayer
var music_muted := false
var music_tween : Tween

# SFX
var sfx_muted := false
var SFX_BUS_ID := AudioServer.get_bus_index("SFX")

func play_music(track: AudioStream):
	if music_player and music_player.stream == track:
		return
	
	# Fade out old track
	if music_player:
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", -80.0, 1.0)
		music_tween.tween_callback(music_player.queue_free)
	
	# Start new track
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = track
	music_player.bus = "Music"
	music_player.volume_db = 0.0 if !music_muted else -80.0
	music_player.play()
	music_player.finished.connect(music_player.play)

# Toggle Functions
func toggle_music_mute(mute: bool):
	music_muted = mute
	if music_player:
		music_player.volume_db = -80.0 if mute else 0.0

func toggle_sfx_mute(mute: bool):
	sfx_muted = mute
	AudioServer.set_bus_mute(SFX_BUS_ID, mute)
