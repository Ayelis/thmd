# Police.gd
extends TextureRect

func _ready():
	$Leave.pressed.connect(_on_leave_pressed)

func _on_leave_pressed():
	GameManager.change_room("Transit")
