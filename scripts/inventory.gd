extends Control

@onready var grid = $Panel/GridContainer
var empty_slot_texture = preload("res://assets/Items/blank.jpg")

func _ready():
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)
	GameManager.inventory_updated.connect(_on_item_updated)
	GameManager.inventory_full_refresh.connect(update_inventory)
	$Panel/Exit.pressed.connect(_on_exit_pressed)
	# Create slots
	for i in range(12):
		var slot = TextureButton.new()
		slot.custom_minimum_size = Vector2(112, 112)
		slot.ignore_texture_size = true
		slot.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		slot.texture_normal = empty_slot_texture
		slot.mouse_entered.connect(_on_slot_hover.bind(i))
		slot.mouse_exited.connect(_on_slot_exit)
		grid.add_child(slot)
	update_inventory()
	GameManager.display_dialog(GameManager.events["home1"])

func _on_item_updated(_item_id):
	update_inventory()

func update_inventory():
	var owned_items = []
	for item_id in GameManager.inventory:
		if GameManager.inventory[item_id]:
			owned_items.append(item_id)
	
	for i in range(grid.get_child_count()):
		var slot = grid.get_child(i)
		if i < owned_items.size():
			var item_id = owned_items[i]
			var item_data = GameManager.ITEMS[item_id]
			slot.texture_normal = load("res://assets/Items/item_%s.jpg" % GameManager.ItemIDs.keys()[item_id].to_lower())
			slot.tooltip_text = "%s\n\n%s" % [item_data.name, item_data.description]
		else:
			slot.texture_normal = empty_slot_texture
			slot.tooltip_text = ""

func _on_slot_hover(slot_index):
	grid.get_child(slot_index).modulate = Color(1.2, 1.2, 1.2)

func _on_slot_exit():
	for slot in grid.get_children():
		slot.modulate = Color.WHITE

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
	visible = false
