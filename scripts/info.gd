#info.gd
extends Control

@onready var info_container = $Panel/ScrollContainer/VBoxContainer

func _ready():
	GameManager.info_full_refresh.connect(_update_info_display)
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)
	_update_info_display()

	# Connect button signals
	$Panel/Exit.pressed.connect(_on_exit_pressed)

func _update_theme(is_dark_mode: bool):
	var loc = "res://assets/UI"
	if is_dark_mode:
		$Panel.texture = load("%s/dark_paper.png" % [loc])
		$Panel/Exit.texture_normal = load("%s/Rect-Dark-Default/Exit@4x.png" % [loc])
		$Panel/Exit.texture_hover = load("%s/Rect-Dark-Hover/Exit@4x.png" % [loc])
		$Panel/Exit.texture_pressed = $Panel/Exit.texture_hover
	else:
		$Panel.texture = load("%s/light_paper.png" % [loc])
		$Panel/Exit.texture_normal = load("%s/Rect-Light-Default/Exit@4x.png" % [loc])
		$Panel/Exit.texture_hover = load("%s/Rect-Light-Hover/Exit@4x.png" % [loc])
		$Panel/Exit.texture_pressed = $Panel/Exit.texture_hover

func _on_exit_pressed():
	self.visible = false
	print("Info closed!")

func _update_info_display():
	# Clear existing labels (keep first child if it's a title)
	for child in info_container.get_children():
		if child.name != "TitleLabel":
			child.queue_free()
	
	# Add discovered info as text lines
	for info_id in GameManager.InfoIDs.values():
		if GameManager.knows_info(info_id):
			var desc_label = Label.new()
			desc_label.text = "- "+GameManager.INFORMATION[info_id]["description"]
			desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			desc_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
			info_container.add_child(desc_label)

func _get_info_icon(info_id: int) -> Texture2D:
	var icon_path = "res://assets/Info/info_%s.png" % GameManager.InfoIDs.keys()[info_id]
	return load(icon_path) if ResourceLoader.exists(icon_path) else null

func _show_info_details(info_id: int):
	var info_data = GameManager.INFORMATION[info_id]
	$InfoDetailPanel.show_info(info_data["name"], info_data["description"])
