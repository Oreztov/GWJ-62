extends CanvasLayer

@onready var interact_key

# Called when the node enters the scene tree for the first time.
func _ready():
	for action in InputMap.action_get_events("interact"):
		interact_key = action.as_text().split(" ")[0]
	$PanelContainer/Label.text = $PanelContainer/Label.text % interact_key
	
	visible = false

func update():
	$PanelContainer.global_position = get_parent().global_position - Vector2(105, 80)
	if visible:
		$AnimationPlayer.play("pop_out")
	else:
		visible = true
		$AnimationPlayer.play("pop_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pop_out":
		visible = false
