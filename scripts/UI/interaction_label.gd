extends CanvasLayer

@onready var interact_key

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.hotkeys_updated.connect(update)
	
	update()
	
	visible = false
		
func enable():
	$PanelContainer.global_position = get_parent().global_position - Vector2(105, 80)
	visible = true
	$AnimationPlayer.play("pop_in")
	
func disable():
	$AnimationPlayer.play("pop_out")

func update():
	# Get hotkey
	for action in InputMap.action_get_events("interact"):
		interact_key = action.as_text().split(" ")[0]
	$PanelContainer/Label.text = "[%s]" % interact_key
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pop_out":
		visible = false
