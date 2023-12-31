extends CharacterBody2D

var base_speed = 250
var speed = base_speed
var hand = Globals.Resources.EMPTY
var invincible = false

var last_direction = Vector2.ZERO
var knockback_velocity = Vector2.ZERO

@export var weapon_carrot: PackedScene
@export var weapon_pumpkin: PackedScene

func _ready():
	Globals.player_reference = self
	
	$HandSprite.play("empty")
	$SoulLight.enabled = false
	
	$TopPart.play("walk")
	$BottomPart.play("walk")
	$TopPart.play("idle")
	$BottomPart.play("idle")

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	var direction = Vector2(direction_x, direction_y).normalized()
	if direction:
		last_direction = direction
		velocity = direction * speed
		# Play walk animation
		$TopPart.play("walk")
		$BottomPart.play("walk")
		if direction.x < 0:
			$TopPart.flip_h = true
			$BottomPart.flip_h = true
		elif direction.x > 0:
			$TopPart.flip_h = false
			$BottomPart.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, speed / 2)
		velocity.y = move_toward(velocity.y, 0, speed / 2)
		$TopPart.play("idle")
		$BottomPart.play("idle")
	
	# Apply knockback
	velocity += knockback_velocity
	knockback_velocity = Vector2.ZERO
	
	move_and_slide()
	
	# Get inventory item inputs
	# Carrot
	if Input.is_action_just_pressed("use_carrot") and Globals.inv[Globals.Plants.CARROT] > 0:
		var new_carrot = weapon_carrot.instantiate()
		new_carrot.position = position
		# Point towards where your direction
		new_carrot.rotation = last_direction.angle()
		get_parent().call_deferred("add_child", new_carrot)
		$Use.play()
		Globals.inv[Globals.Plants.CARROT] -= 1
		Globals.hud_reference.update_inventory()
	# Pumpkin
	elif Input.is_action_just_pressed("use_pumpkin") and Globals.inv[Globals.Plants.PUMPKIN] > 0:
		var new_pumpkin = weapon_pumpkin.instantiate()
		# Spawn at legs
		new_pumpkin.position = position + $CollisionShape2D.position
		new_pumpkin.parent = true
		get_parent().call_deferred("add_child", new_pumpkin)
		$Use.play()
		Globals.inv[Globals.Plants.PUMPKIN] -= 1
		Globals.hud_reference.update_inventory()
	elif  Input.is_action_just_pressed("use_heart") and Globals.inv[Globals.Plants.HEART] > 0 and Globals.hud_reference.get_hp() < 100:
		Globals.hud_reference.add_hp(30)
		$Use.play()
		Globals.inv[Globals.Plants.HEART] -= 1
		Globals.hud_reference.update_inventory()

func set_hand_item(item):
	hand = item
	$SoulLight.enabled = false
	match item:
		Globals.Resources.COMPOST:
			$HandSprite.play("compost")
		Globals.Resources.SOUL:
			$HandSprite.play("soul")
			$SoulLight.enabled = true
		Globals.Resources.WATER:
			$HandSprite.play("water")
		_:
			$HandSprite.play("empty")
	if hand != Globals.Resources.EMPTY:
		$PickUp.play()

func attacked(amount, source_pos = Vector2.ZERO, knockback_amount = 100):
	# Take damage
	Globals.hud_reference.sub_hp(amount)
	# Iframes
	invincible = true
	$Invincibility.start(1.0)
	# Knockback
	var knockback_dir = (position - source_pos).normalized()
	knockback_velocity = knockback_dir * knockback_amount

func _on_invincibility_timeout():
	invincible = false
