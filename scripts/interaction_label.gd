extends CanvasLayer

@onready var interact_key

# Called when the node enters the scene tree for the first time.
func _ready():
	for action in InputMap.action_get_events("interact"):
		interact_key = action.as_text().split(" ")[0]
	$PanelContainer/Label.text = $PanelContainer/Label.text % interact_key

func update():
	$PanelContainer.global_position = get_parent().global_position - Vector2(105, 80)
	visible = !visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

