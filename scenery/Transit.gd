# Transit.gd
extends TextureRect

func _ready():
	print("Transit area ready!")
	$Home.pressed.connect(_on_home_pressed)
	$Library.pressed.connect(_on_lib_pressed)
	$Police.pressed.connect(_on_police_pressed)
	$Beach.pressed.connect(_on_beach_pressed)
	$Mansion.pressed.connect(_on_mansion_pressed)

func _on_home_pressed():
	print("Lightrail boarded!")
	get_parent().get_parent().change_room("Home")

func _on_lib_pressed():
	print("Lightrail boarded!")
	get_parent().get_parent().change_room("Library")

func _on_police_pressed():
	print("Lightrail boarded!")
	get_parent().get_parent().change_room("Police")

func _on_beach_pressed():
	print("Lightrail boarded!")
	get_parent().get_parent().change_room("Beach")

func _on_mansion_pressed():
	print("Lightrail boarded!")
	get_parent().get_parent().change_room("Mansion")
