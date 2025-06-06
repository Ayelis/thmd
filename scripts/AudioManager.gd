extends Node

# Music
var music_player : AudioStreamPlayer
var music_muted := false
var music_tween : Tween

# SFX
var sfx_muted := false
var SFX_BUS_ID := AudioServer.get_bus_index("SFX")
var MUS_BUS_ID := AudioServer.get_bus_index("Music")

func _ready():
	# Initialize with default values matching Global
	music_muted = Global.silenced
	sfx_muted = Global.muted

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

func stop_music():
	music_player.stop()

func restart_music():
	music_player.play()
