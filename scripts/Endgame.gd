extends Control

@onready var the_end_label = $TheEndLabel  # Add a Label node for "The End"
var dialogue_closed = false

func _ready():
	$Button.pressed.connect(_on_button_pressed)
	# Connect signals
	GameManager.ending_updated.connect(_on_ending_updated)
	# Start hidden
	visible = false
	the_end_label.visible = false  # Hide initially

func _on_ending_updated(text: String, title: String, texture: String = "", timbre: String = ""):
	# Update the RichTextLabel with the new dialogue
	var scene_label = get_tree().root.find_child("Scene", true, false)
	if scene_label and scene_label is Label:
		scene_label.text = title
	if(texture != ""):
		$Padding.texture = load("res://assets/Scenes/"+texture+".jpg")
	else:
		$Padding.texture = load("res://assets/Scenes/padded.jpg")
	await get_tree().process_frame
	GameManager.display_dialog(GameManager.endings[text])
	await get_tree().process_frame
	AudioManager.play_music(load("res://assets/audio/"+timbre+".ogg"))
	await get_tree().process_frame
	_show()  # Make sure the panel is visible when new text arrives
	await GameManager.dialogue_closed  # Wait for the signal
	# Now trigger "The End" animation
	_show_the_end_animation()

func _show_the_end_animation():
	_show()  # Make panel visible
	the_end_label.visible = true
	the_end_label.text = ""
	
	# Typewriter effect
	var final_text = "The End"
	for i in range(final_text.length() + 1):
		the_end_label.text = final_text.substr(0, i)
		await get_tree().create_timer(0.1).timeout  # Adjust speed here
	$Button.show()

func _on_button_pressed():
	$Button.hide()
	the_end_label.visible = false  # Hide initially
	Global.reset()

func _show():
	visible = true

func _hide():
	visible = false
