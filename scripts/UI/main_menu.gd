extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.ingame:
		visible = false
		$PanelContainer/VBoxContainer/PlayButton.text = "Continue!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event):
	# Pausing
	if Globals.ingame:
		if event.is_action_pressed("ui_cancel"):
			get_tree().paused = !get_tree().paused
			visible = !visible

func _on_play_button_pressed():
	# Start game
	if not Globals.ingame:
		Globals.ingame = true
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	# Continue game
	else:
		get_tree().paused = false
		visible = false


func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
