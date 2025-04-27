# Home.gd
extends TextureRect

func _ready():
	print("Home ready!")
	$Door.pressed.connect(_on_door_pressed)

func _on_door_pressed():
	print("Door opened!")
	get_parent().get_parent().change_room("Transit")
