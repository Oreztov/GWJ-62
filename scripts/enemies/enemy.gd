extends CharacterBody2D


@export var speed = 150
@export var health = 100

@onready var nav_agent = $NavigationAgent2D

var next_pos

func ready():
	pass

func _physics_process(delta):
	# Death
	if health <= 0:
		queue_free()
	
	if nav_agent.is_navigation_finished():
		set_velocity(Vector2.ZERO)
		move_and_slide()
		return
	
	set_velocity(handle_movement())
	
	if velocity != Vector2.ZERO:
		# Play walk animation
		$TopPart.play("walk")
		$BottomPart.play("walk")
		if velocity.x < 0:
			$TopPart.flip_h = true
			$BottomPart.flip_h = true
			$EnemyShadow.skew = 60
		elif velocity.x > 0:
			$TopPart.flip_h = false
			$BottomPart.flip_h = false
			$EnemyShadow.skew = -60
	else:
		$TopPart.play("idle")
		$BottomPart.play("idle")
	
	move_and_slide()
	
func handle_movement():
	nav_agent.target_position = Globals.player_reference.global_position
	# Calculate and set agent velocity towards next waypoint
	var current_agent_position: Vector2 = global_transform.origin
	var next_path_position: Vector2 = nav_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * speed
	
	return new_velocity
	
func find_path():
	nav_agent.target_position = Globals.player_reference.global_position

func _on_nav_update_timer_timeout():
	find_path()


func _on_rot_timer_timeout():
	# Naturally rot away
	health -= 1
