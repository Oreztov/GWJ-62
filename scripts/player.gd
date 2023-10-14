extends CharacterBody2D

var base_speed = 250
var speed = base_speed
var hand = Globals.Resources.EMPTY

func _ready():
	$HandSprite.play("empty")

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	var direction = Vector2(direction_x, direction_y).normalized()
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func set_hand_item(item):
	hand = item
	match item:
		Globals.Resources.COMPOST:
			$HandSprite.play("compost")
		Globals.Resources.SOUL:
			$HandSprite.play("soul")
		Globals.Resources.WATER:
			$HandSprite.play("water")
		_:
			$HandSprite.play("empty")
			
