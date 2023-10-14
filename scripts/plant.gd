extends Node2D
var stage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("sprout")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and stage < 3:
		if body.hand == Globals.Resources.COMPOST:
			stage += 1
			body.hand = Globals.Resources.EMPTY
			match stage:
				1:
					$AnimatedSprite2D.play("sprout")
				2:
					$AnimatedSprite2D.play("growth")
				3:
					$AnimatedSprite2D.play("harvest")
