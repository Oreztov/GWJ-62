extends Control

var dead = false

var initial_hiscore_text

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainContainer.visible = true
	$MainContainer/VBoxContainer/PlayButton.grab_focus()
	$SettingsContainer.visible = false
	$HelpContainer.visible = false
	if Globals.ingame:
		visible = false
		$MainContainer/VBoxContainer/PlayButton.text = "Continue!"
		
	Globals.game_over.connect(game_over)
	$GameOver.hide()
	
	dead = false
	
	initial_hiscore_text = $HiScoreContainer/HiScoreLabel.text
	$HiScoreContainer/HiScoreLabel.text = initial_hiscore_text % SaveSystem.get_var("high_score", 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event):
	# Pausing
	if Globals.ingame and not dead:
		if event.is_action_pressed("ui_cancel"):
			get_tree().paused = !get_tree().paused
			_on_back_button_pressed()
			visible = !visible
			if visible:
				$MainContainer/VBoxContainer/PlayButton.grab_focus()

func _on_play_button_pressed():
	if not dead:
		# Start game
		if not Globals.ingame:
			Globals.ingame = true
			get_tree().change_scene_to_file("res://scenes/level.tscn")
		# Continue game
		else:
			get_tree().paused = false
			visible = false
	else:
		# Restart game
		$GameOver.hide()
		get_tree().reload_current_scene()

func _on_settings_button_pressed():
	# To settings menu
	$MainContainer.visible = false
	$SettingsContainer.visible = true
	$SettingsContainer/VBoxContainer/ScrollContainer/VBoxContainer/VolumeContainer/Slider/Slider.grab_focus()

func _on_back_button_pressed():
	# Back to main menu
	$MainContainer.visible = true
	$SettingsContainer.visible = false
	$HelpContainer.visible = false
	$MainContainer/VBoxContainer/PlayButton.grab_focus()

func _on_help_button_pressed():
	# To Help Menu
	$MainContainer.visible = false
	$HelpContainer.visible = true
	$HelpContainer/VBoxContainer/BackButton.grab_focus()
	
func game_over():
	get_tree().paused = true
	_on_back_button_pressed()
	visible = true
	$MainContainer/VBoxContainer/PlayButton.grab_focus()
	$MainContainer/VBoxContainer/PlayButton.text = "Restart!"
	$GameOver.show()
	dead = true
	$HiScoreContainer/HiScoreLabel.text = initial_hiscore_text % SaveSystem.get_var("high_score", 0)


func _on_main_container_visibility_changed():
	$CreditsContainer.visible = $MainContainer.visible
	$HiScoreContainer.visible = $MainContainer.visible
