extends Control

signal close_requested

@onready var item_image: TextureRect = $Image
@onready var item_title: Label = $Title
@onready var item_description: RichTextLabel = $Description

func update_display(texture: Texture2D, title: String, description: String):
	item_image.texture = texture
	item_title.text = title
	item_description.text = description
