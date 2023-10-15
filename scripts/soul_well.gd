extends StaticBody2D

var player_in_area = false

var player_reference

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	
func _input(event):
	if player_in_area:
		if event.is_action_pressed("interact"):
			player_reference.set_hand_item(Globals.Resources.SOUL)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$InteractionLabel.update()
		player_in_area = true
		player_reference = body


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		$InteractionLabel.update()
		player_in_area = false
