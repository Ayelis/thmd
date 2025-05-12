# Aspect.gd (Global Autoload)
extends Node

const BASE_WIDTH := 360.0
const BASE_HEIGHT := 620.0
var scale_factor := 1.0
var safe_area_insets := Rect2()  # For mobile devices with notches

signal scale_updated(scale_factor, viewport_size)

func _ready():
	# Set initial window size for desktop platforms
	if OS.get_name() in ["Windows", "macOS", "Linux", "HTML5"]:
		get_window().size = Vector2i(BASE_WIDTH, BASE_HEIGHT)
	
	_update_scale()
	get_viewport().size_changed.connect(_update_scale)

func _update_scale():
	var viewport_size := get_viewport().get_visible_rect().size
	scale_factor = min(viewport_size.x / BASE_WIDTH, viewport_size.y / BASE_HEIGHT)
	
	# Handle mobile safe areas
	if OS.get_name() in ["Android", "iOS"]:
		var display_size := DisplayServer.screen_get_size()
		var usable_rect := DisplayServer.get_display_safe_area()
		safe_area_insets = Rect2(
			(1.0*usable_rect.position.x / display_size.x),
			(1.0*usable_rect.position.y / display_size.y),
			(1.0*(display_size.x - usable_rect.end.x) / display_size.x),
			(1.0*(display_size.y - usable_rect.end.y) / display_size.y)
		)
	
	emit_signal("scale_updated", scale_factor, viewport_size)
