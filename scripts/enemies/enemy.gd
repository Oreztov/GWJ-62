extends CharacterBody2D


@export var speed = 150
@export var health = 100
@export var damage = 20
@export var attack_frame = 2
@export var knockback_amount = 750

@onready var nav_agent = $NavigationAgent2D
var next_pos

var initial_pos = Vector2.ZERO
var initial_hp

var spawned = false
var deter = false
var attacking = false
var allowed_to_move = true

func _ready():
	initial_pos = position
	initial_hp = health
	# Spawn animation
	position.y += 16
	var tween = create_tween()
	tween.tween_property(self, "position", initial_pos, 1)
	tween.tween_callback(func(): spawned = true)
	$DirtParticles.play("default")
	
	$AttackArea.monitoring = false

func _physics_process(delta):
	# Death
	if spawned:
		if health <= 0:
			# Award score
			Globals.add_score(25)
			Globals.enemy_died.emit()
			queue_free()
			
		if allowed_to_move:
		
			if nav_agent.is_navigation_finished():
				set_velocity(Vector2.ZERO)
				move_and_slide()
				return
			
			set_velocity(handle_movement())
			
			if velocity != Vector2.ZERO:
				# Play walk animation
				if not attacking:
					if deter:
						$TopPart.play("deter_walk")
						$BottomPart.play("deter_walk")
					else:
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
			elif not attacking:
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
	take_damage(1)

func take_damage(amount):
	health -= amount
	if health <= (0.5 * initial_hp):
		deter = true
	
	
func attack():
	# Start attack, activate hitbox
	if deter:
		$TopPart.play("deter_attack")
		$BottomPart.play("deter_attack")
	else:
		$TopPart.play("attack")
		$BottomPart.play("attack")
	attacking = true
	allowed_to_move = false

func _on_hitbox_area_body_entered(body):
	if body.is_in_group("player") and not attacking:
		attack()


func _on_top_part_animation_finished():
	# Stop attack, disable hitbox
	if $TopPart.animation == "attack" or $TopPart.animation == "deter_attack":
		$AttackArea.monitoring = false
		attacking = false
		allowed_to_move = true


func _on_attack_area_area_entered(area):
	if area.is_in_group("player"):
		Globals.player_reference.attacked(damage, position, knockback_amount)


func _on_top_part_frame_changed():
	if $TopPart.animation == "attack" or $TopPart.animation == "deter_attack":
		if $TopPart.frame == attack_frame:
			$AttackArea.monitoring = true
