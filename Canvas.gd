extends Control

const BASE_WIDTH = 360.0
const BASE_HEIGHT = 620.0

var previous_size = Vector2.ZERO

func _ready():
	_update_scale()

func _process(_delta):
	var current_size = get_viewport().get_visible_rect().size
	if current_size != previous_size:
		previous_size = current_size
		_update_scale()

func _update_scale():
	var viewport_size = get_viewport().get_visible_rect().size
	var scale_factor = min(viewport_size.x / BASE_WIDTH, viewport_size.y / BASE_HEIGHT)
	$CanvasLayer/UI.scale = Vector2(scale_factor, scale_factor)
	$CanvasLayer/UI.position = (viewport_size - ($CanvasLayer/UI.size * scale_factor)) / 2
