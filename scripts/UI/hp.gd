extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$hp_bar.value = $hp_bar.max_value
	update_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_hp(health):
	$hp_bar.value += health
	update_text()

func sub_hp(health):
	$hp_bar.value -= health
	update_text()
	if $hp_bar.value <= 0:
		get_tree().reload_current_scene()
		
func get_hp():
	return $hp_bar.value

func update_text():
	$hp_label.text = str($hp_bar.value)
	
	
