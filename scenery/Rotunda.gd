# Altar.gd
extends TextureRect
var this_room = "Rotunda"

func _ready():
	$Blood.pressed.connect(_on_blood_pressed)
	$Circle.pressed.connect(_on_circle_pressed)
	$Altar.pressed.connect(_on_altar_pressed)
	$Skylights.pressed.connect(_on_skylights_pressed)
	#$Door1.pressed.connect(_on_door_pressed)
	#$Door2.pressed.connect(_on_door_pressed)
	$Daughter.pressed.connect(_on_daughter_pressed)
	GameManager.room_changed.connect(_on_room_changed)

func _on_room_changed(room_name: String):	
	if(room_name == this_room):
		if(GameManager.knows_info(GameManager.InfoIDs.SMASH)):
			GameManager.initiate_dialogue("crowdsource-mansion")
		else:
			GameManager.initiate_dialogue("enter-mansion")

func _on_blood_pressed():
	GameManager.insane(GameManager.insanity["blood"])
	$Blood.hide()
func _on_circle_pressed():
	GameManager.insane(GameManager.insanity["magic"])
func _on_altar_pressed():
	GameManager.display_dialog(GameManager.events["altar"])
func _on_skylights_pressed():
	GameManager.display_dialog(GameManager.events["skylight"])
func _on_door_pressed():
	GameManager.display_dialog(GameManager.events["leave"])
func _on_daughter_pressed():
	GameManager.initiate_dialogue("daughter")
