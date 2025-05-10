# ThemeManager.gd
extends Node

var current_theme: Theme

func apply_theme(theme_path: String):
	print(theme_path)
	current_theme = load(theme_path)
	if current_theme == null:
		printerr("Failed to load theme at: ", theme_path)
	update_all_buttons()

func update_all_buttons():
	print("U.A.B.")
	for button in get_tree().get_nodes_in_group("ui_button"):
		print(button)
		print(current_theme)
		button.theme = current_theme
