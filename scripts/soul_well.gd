extends StaticBody2D

var player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	
func _input(event):
	if player_in_area:
		if event.is_action_pressed("interact"):
			Globals.player_reference.set_hand_item(Globals.Resources.SOUL)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$InteractionLabel.enable()
		player_in_area = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		$InteractionLabel.disable()
		player_in_area = false
