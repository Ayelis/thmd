# Attic.gd
extends TextureRect

func _ready():
	print("Attic area ready!")
	$Rope.pressed.connect(_on_rope_pressed)
	$Drawers.pressed.connect(_on_drawers_pressed)
	$Window.pressed.connect(_on_window_pressed)
	$Vines.pressed.connect(_on_vines_pressed)

func _on_rope_pressed():
	print("Rope gathered!")
	if(!GameManager.inventory[GameManager.ItemIDs.ROPE]):
		GameManager.obtain_item(GameManager.ItemIDs.ROPE)
		GameManager.display_dialog()
		$Rope.disabled = true

func _on_drawers_pressed():
	print("Drawers accessed!")
	if(!GameManager.inventory[GameManager.ItemIDs.ROBE]):
		GameManager.display_dialog()
		GameManager.obtain_item(GameManager.ItemIDs.ROBE)
		$Drawers.disabled = true

func _on_window_pressed():
	print("Window pondered!")
	GameManager.display_dialog()
	GameManager.obtain_item(GameManager.ItemIDs.DETECTOR)
	$Window.disabled = true

func _on_vines_pressed():
	print("Vines explored!")
	GameManager.display_dialog()
	GameManager.increase_insanity()
	$Vines.disabled = true
