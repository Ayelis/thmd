#title_screen.gd
extends Node2D

func _ready():
	$BG/Title.modulate.a = 0
	$BG/AnimationPlayer.play("fade")
	$BG/Start.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")
