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
	GameManager.insane(GameManager.insanity["blood"])
	print("Blood!")
func _on_circle_pressed():
	GameManager.display_dialog(GameManager.events["magic"])
	print("Circle!")
func _on_altar_pressed():
	GameManager.display_dialog(GameManager.events["altar"])
	print("Altar!")
func _on_skylights_pressed():
	GameManager.display_dialog(GameManager.events["skylight"])
	print("Skylights!")
func _on_door_pressed():
	GameManager.display_dialog(GameManager.events["leave"])
	print("Door!")
func _on_daughter_pressed():
	print("Daughter!")
	GameManager.initiate_dialogue("daughter")
	GameManager.hard_reset()
