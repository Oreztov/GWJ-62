extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$hp_bar.value = $hp_bar.max_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_hp(health):
	$hp_bar.value += health

func sub_hp(health):
	$hp_bar.value -= health
	if $hp_bar.value <= 0:
		get_tree().reload_current_scene()
	
