extends Control

@onready var grid = $Panel/GridContainer
@onready var details_panel = $ItemDetailsPanel
var empty_slot_texture = preload("res://assets/Items/blank.jpg")
var selected_slot_index = -1

func _ready():
	Global.theme_changed.connect(_update_theme)
	_update_theme(Global.dark_mode)
	GameManager.inventory_updated.connect(_on_item_updated)
	GameManager.inventory_full_refresh.connect(update_inventory)
	$Panel/Exit.pressed.connect(_on_exit_pressed)
	
	# Initialize details panel
	details_panel.visible = false
	details_panel.close_requested.connect(_close_details_panel)
	
	# Create slots
	for i in range(12):
		var slot = TextureButton.new()
		slot.custom_minimum_size = Vector2(112, 112)
		slot.ignore_texture_size = true
		slot.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		slot.texture_normal = empty_slot_texture
		slot.mouse_entered.connect(_on_slot_hover.bind(i))
		slot.mouse_exited.connect(_on_slot_exit)
		slot.pressed.connect(_on_slot_clicked.bind(i))
		grid.add_child(slot)
	update_inventory()
	GameManager.display_dialog(GameManager.events["home1"])

func _on_slot_clicked(slot_index):
	var owned_items = []
	for item_id in GameManager.inventory:
		if GameManager.inventory[item_id]:
			owned_items.append(item_id)
	
	if slot_index < owned_items.size():
		selected_slot_index = slot_index
		var item_id = owned_items[slot_index]
		var item_data = GameManager.ITEMS[item_id]
		_show_details_panel(item_data)

func is_mobile() -> bool:
	return OS.has_feature("mobile") or OS.has_feature("web_mobile")

func _show_details_panel(item_data):
	details_panel.update_display(
		load("res://assets/Items/item_%s.jpg" % GameManager.ItemIDs.keys()[item_data.id].to_lower()),
		item_data.name,
		item_data.description
	)
	details_panel.visible = true
	
	# Position the panel near the clicked slot
	var slot = grid.get_child(selected_slot_index)
	var slot_rect = slot.get_global_rect()
	
	# Adjust position based on available space
	var viewport_size = get_viewport_rect().size
	if slot_rect.position.x + details_panel.size.x > viewport_size.x:
		details_panel.position.x = viewport_size.x - details_panel.size.x
	else:
		details_panel.position.x = slot_rect.position.x
		
	if slot_rect.position.y + slot_rect.size.y + details_panel.size.y > viewport_size.y:
		details_panel.position.y = slot_rect.position.y - details_panel.size.y
	else:
		details_panel.position.y = slot_rect.position.y + slot_rect.size.y

func _close_details_panel():
	details_panel.visible = false
	selected_slot_index = -1

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
			#slot.tooltip_text = "%s\n\n%s" % [item_data.name, item_data.description]
		else:
			slot.texture_normal = empty_slot_texture
			#slot.tooltip_text = ""

func _on_slot_hover(slot_index):
	grid.get_child(slot_index).modulate = Color(1.2, 1.2, 1.2)
	if not is_mobile():
		show_item_details(slot_index)

func _on_slot_exit():
	for slot in grid.get_children():
		slot.modulate = Color.WHITE
	if not is_mobile():
		hide_item_details()

func show_item_details(slot_index: int):
	var owned_items = get_owned_items()
	if slot_index >= owned_items.size():
		return
	var item_id = owned_items[slot_index]
	var item_data = GameManager.ITEMS[item_id]
	# Update panel content
	details_panel.update_display(
		load("res://assets/Items/item_%s.jpg" % GameManager.ItemIDs.keys()[item_id].to_lower()),
		item_data.name,
		item_data.description
	)
	# Position and show
	details_panel.visible = true
	position_panel_near_slot(slot_index)

func hide_item_details():
	details_panel.visible = false

func get_owned_items() -> Array:
	return GameManager.inventory.keys().filter(func(id): return GameManager.inventory[id])

func position_panel_near_slot(slot_index: int):
	var slot = grid.get_child(slot_index)
	var slot_rect = slot.get_global_rect()
	var panel_size = details_panel.size
	# Position logic (example - adjust as needed)
	if(slot_rect.end.y < 300):
		details_panel.position = Vector2(
			clamp(slot_rect.position.x, 0, get_viewport_rect().size.x - panel_size.x),
			clamp(slot_rect.end.y + 20, 0, get_viewport_rect().size.y - panel_size.y)
		)
	else:
		details_panel.position = Vector2(
			clamp(slot_rect.position.x, 0, get_viewport_rect().size.x - panel_size.x),
			clamp(slot_rect.end.y - 375, 0, get_viewport_rect().size.y - panel_size.y)
		)

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
