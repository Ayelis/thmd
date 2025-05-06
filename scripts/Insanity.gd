extends Control

@onready var the_end_label = $TheEndLabel  # Add a Label node for "The End"
var dialogue_closed = false

func _ready():
	# Connect signals
	GameManager.ending_updated.connect(_on_ending_updated)
	# Start hidden
	visible = false
	the_end_label.visible = false  # Hide initially
	print("Ending System ready")

func _on_ending_updated(text: String, title: String, texture: String = "", timbre: String = ""):
	# Update the RichTextLabel with the new dialogue
	var scene_label = get_tree().root.find_child("Scene", true, false)
	if scene_label and scene_label is Label:
		scene_label.text = title
	if(texture != ""):
		$Padded.texture = load("res://assets/Scenes/"+texture+".jpg")
	GameManager.display_dialog(GameManager.endings[text])
	await get_tree().process_frame
	AudioManager.play_music(load("res://assets/audio/"+timbre+".ogg"))
	_show()  # Make sure the panel is visible when new text arrives
	await GameManager.dialogue_closed  # Wait for the signal
	print("GMdc")
	# Now trigger "The End" animation
	_show_the_end_animation()

func _show_the_end_animation():
	print("STEA")
	_show()  # Make panel visible
	the_end_label.visible = true
	the_end_label.text = ""
	
	# Typewriter effect
	var final_text = "The End"
	for i in range(final_text.length() + 1):
		the_end_label.text = final_text.substr(0, i)
		await get_tree().create_timer(0.1).timeout  # Adjust speed here
	print("timed")

func _show():
	visible = true
	print("Ending open!")

func _hide():
	visible = false
	print("Ending closed!")
