# Canvas.gd (Attached to Root control node)
extends Control

@onready var dlg = $CanvasLayer/Dialogue

func _ready():
	DialogueManager.set_dialogue_node(dlg)
	Aspect.scale_updated.connect(_on_scale_updated)
	_on_scale_updated(Aspect.scale_factor, get_viewport().get_visible_rect().size)

func _on_scale_updated(size: float, viewport_size: Vector2):
	$CanvasLayer/UI.scale = Vector2(size, size)
	$CanvasLayer/UI.position = (viewport_size - ($CanvasLayer/UI.size * scale)) / 2
