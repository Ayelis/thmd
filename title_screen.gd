#title_screen.gd
extends Node2D

func _ready():
	$Title.modulate.a = 0
	$Title/AnimationPlayer.play("fade")

	if $Start:
		$Start.hide()  # Hide initially
		$Start.pressed.connect(_on_start_pressed)
	else:
		print("Error: StartButton missing!")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
