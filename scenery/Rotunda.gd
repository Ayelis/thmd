# Altar.gd
extends TextureRect

func _ready():
	print("Rotunda area ready!")
	$Blood.pressed.connect(_on_blood_pressed)
	$Circle.pressed.connect(_on_circle_pressed)
	$Altar.pressed.connect(_on_altar_pressed)
	$Skylights.pressed.connect(_on_skylights_pressed)
	$Door1.pressed.connect(_on_door_pressed)
	$Door2.pressed.connect(_on_door_pressed)
	$Daughter.pressed.connect(_on_daughter_pressed)
func _on_blood_pressed():
	print("Blood!")
func _on_circle_pressed():
	print("Circle!")
func _on_altar_pressed():
	print("Altar!")
func _on_skylights_pressed():
	print("Skylights!")
func _on_door_pressed():
	print("Door!")
func _on_daughter_pressed():
	print("Daughter!")
	GameManager.display_dialog(GameManager.insanity["blood"])
	GameManager.hard_reset()
