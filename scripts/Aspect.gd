extends Node

# Configuration
const BASE_SIZE := Vector2(360, 620)
const TARGET_ASPECT := float(BASE_SIZE.x) / float(BASE_SIZE.y)

# State
var _resize_timer := Timer.new()
var _is_resizing := false
var _last_direction := 0 # 0=neutral, 1=horizontal, 2=vertical

func _ready():
	# Setup timer for smooth resizing
	add_child(_resize_timer)
	_resize_timer.wait_time = 0.1
	_resize_timer.one_shot = true
	_resize_timer.timeout.connect(_finalize_resize)
	
	# Connect signals
	var window := get_window()
	window.size_changed.connect(_on_resize)
	window.connect("window_mode_changed", Callable(self, "_on_mode_changed"))
	
	# Initial size (200% scale)
	# window.size = BASE_SIZE * 2.0
	window.size = Vector2(BASE_SIZE.x * 2.0, BASE_SIZE.y * 2.0 - 200)

func _on_mode_changed():
	if get_window().mode != Window.MODE_FULLSCREEN:
		_on_resize()

func _on_resize():
	if _is_resizing:
		return
	
	var window := get_window()
	var current_size := window.size
	var last_size := window.size
	
	# Detect resize direction
	var mouse_pos := DisplayServer.mouse_get_position()
	var window_rect := Rect2i(window.position, window.size)
	
	if mouse_pos.x >= window_rect.end.x - 2:
		_last_direction = 1 # Horizontal
	elif mouse_pos.y >= window_rect.end.y - 2:
		_last_direction = 2 # Vertical
	
	_is_resizing = true
	_resize_timer.start()

func _finalize_resize():
	var window := get_window()
	
	# Skip in fullscreen
	if window.mode == Window.MODE_FULLSCREEN:
		_apply_fullscreen_scaling()
		_is_resizing = false
		return
	
	var new_size := window.size
	
	# Calculate based on resize direction
	match _last_direction:
		1: # Horizontal resize
			new_size.y = round(new_size.x / TARGET_ASPECT)
		2: # Vertical resize
			new_size.x = round(new_size.y * TARGET_ASPECT)
		_: # Default (corner or programmatic resize)
			var current_aspect := float(new_size.x) / float(new_size.y)
			if current_aspect > TARGET_ASPECT:
				new_size.x = round(new_size.y * TARGET_ASPECT)
			else:
				new_size.y = round(new_size.x / TARGET_ASPECT)
	
	# Apply new size
	if new_size != window.size:
		window.size = new_size
	
	_is_resizing = false
	_last_direction = 0

func _apply_fullscreen_scaling() -> void:
	var screen_size := DisplayServer.screen_get_size()
	var scale_x := floorf(screen_size.x / float(BASE_SIZE.x))
	var scale_y := floorf(screen_size.y / float(BASE_SIZE.y))
	var scale_factor := minf(scale_x, scale_y)

	scale_factor = maxf(scale_factor, 1.0)
	get_tree().root.content_scale_factor = scale_factor
