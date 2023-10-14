extends Node2D

var stage = 1

var player_in_area = false

var player_reference

# Called when the node enters the scene tree for the first time.
func _ready():
	$InteractionLabel.update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if player_in_area:
		if event.is_action_pressed("interact") and stage < 3:
			if player_reference.hand == Globals.Resources.COMPOST or player_reference.hand == Globals.Resources.WATER or player_reference.hand == Globals.Resources.SOUL:
				stage += 1
				player_reference.set_hand_item(Globals.Resources.EMPTY)
				match stage:
					1:
						$AnimatedSprite2D.play("sprout")
					2:
						$AnimatedSprite2D.play("growth")
					3:
						$AnimatedSprite2D.play("harvest")
						$InteractionLabel.update()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and stage < 3:
		$InteractionLabel.update()
		player_in_area = true
		player_reference = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("player") and stage < 3:
		$InteractionLabel.update()
		player_in_area = false
