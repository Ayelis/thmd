# ThemeManager.gd
extends Node

var current_theme: Theme

func apply_theme(theme_path: String):
	current_theme = load(theme_path)
	if current_theme == null:
		printerr("Failed to load theme at: ", theme_path)
	update_all_buttons()

func update_all_buttons():
	for button in get_tree().get_nodes_in_group("ui_button"):
		button.theme = current_theme
