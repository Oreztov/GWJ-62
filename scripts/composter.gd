extends StaticBody2D

signal block_graves(bodies)

var blocked = false

var player_in_area = false

var player_reference

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if player_in_area:
		if event.is_action_pressed("interact"):
			player_reference.set_hand_item(Globals.Resources.COMPOST)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if not blocked:
		var blocked_graves = $BlockArea.get_overlapping_bodies()
		if blocked_graves != []:
			block_graves.emit(blocked_graves)
			blocked = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$InteractionLabel.update()
		player_in_area = true
		player_reference = body


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		$InteractionLabel.update()
		player_in_area = false
