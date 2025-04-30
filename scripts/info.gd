#info.gd
extends Control

func _ready():
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)

	# Connect button signals
	$Panel/Exit.pressed.connect(_on_exit_pressed)

func _update_theme(is_dark_mode: bool):
	var loc = "res://assets/UI"
	if is_dark_mode:
		$Panel.texture = load("%s/dark_paper.png" % [loc])
	else:
		$Panel.texture = load("%s/light_paper.png" % [loc])

func _on_exit_pressed():
	self.visible = false
	print("Info closed!")
