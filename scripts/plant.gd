extends Node2D

@export var plant = Globals.Plants.EMPTY

var stage = 1
var grow_level = 1
var resource_needed = Globals.Resources.EMPTY
var interaction_active = false

var grow_time = 5
var resources_needed = [Globals.Resources.COMPOST, Globals.Resources.WATER, Globals.Resources.SOUL]

@onready var player_in_area = false

@onready var plant_marker

var enemies = [preload("res://scenes/enemies/enemy.tscn"),
preload("res://scenes/enemies/enemy_pumpkin.tscn"),
preload("res://scenes/enemies/enemy_carrot.tscn"),
preload("res://scenes/enemies/enemy_heart.tscn")]

var rng = RandomNumberGenerator.new()

signal freed(marker)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Pick random plant type
	plant = randi_range(1, Globals.Plants.size() - 1)
	$AnimatedSprite2D.play("sprout")
	$AnimatedSprite2D.frame = plant

func ask_for_resource():
	# Get new random resource needed
	var random_resource_index = rng.randi_range(0, len(resources_needed) - 1)
	resource_needed = resources_needed[random_resource_index]
	# Remove resource from list
	resources_needed.remove_at(random_resource_index)
	# Activate Popup
	$AnimationPlayer.play("pop_in")
	match resource_needed:
		Globals.Resources.WATER:
			$PopupBackground/Popup.play("water")
		Globals.Resources.COMPOST:
			$PopupBackground/Popup.play("compost")
		Globals.Resources.SOUL:
			$PopupBackground/Popup.play("soul")
	# Activate interaction
	interaction_active = true
	set_process_input(true)

func consume_resource():
	# Restart grow timer and add to rot timer
	$GrowTimer.start(grow_time)
	$RotTimer.start($RotTimer.time_left + 5)
	# Consume player hand item
	Globals.player_reference.set_hand_item(Globals.Resources.EMPTY)
	$AnimationPlayer.play("pop_out")
	$InteractionLabel.disable()
	resource_needed = Globals.Resources.EMPTY
	# Disable interaction
	interaction_active = false
	player_in_area = false
	set_process_input(false)
	# Award score
	Globals.add_score(10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rot_time
	if grow_level <= 2:
		rot_time = 25
	elif grow_level <= 5:
		rot_time = 45
	elif grow_level <= 6:
		rot_time = 60
	var rot_factor = $RotTimer.time_left / rot_time
	$AnimatedSprite2D.modulate = lerp(Color.DARK_GREEN, Color.WHITE, rot_factor)
	$GPUParticles2D.speed_scale = 1 * ease(1 - rot_factor, 5)
	$PlantLight.modulate.a = lerp(0.5, 0.0, rot_factor) - 0.3
	if rot_factor < 0.5:
		$GPUParticles2D.visible = true
		$PlantLight.visible = true
	else:
		$GPUParticles2D.visible = false
		$PlantLight.visible = false

func _input(event):
	if player_in_area and interaction_active:
		if event.is_action_pressed("interact"):
			if stage < 3:
				# Check for player holding correct item
				if Globals.player_reference.hand == resource_needed:
					consume_resource()
			if stage == 3:
				# Harvest plant
				harvest()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and interaction_active:
		$InteractionLabel.enable()
		player_in_area = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player") and interaction_active:
		$InteractionLabel.disable()
		player_in_area = false

func _on_rot_timer_timeout():
	# Plant has rotted, spawn according zombie
	var new_enemy = enemies[plant].instantiate()
	new_enemy.position = position
	get_parent().add_child(new_enemy)
	new_enemy.add_to_group("enemies")
	
	freed.emit(plant_marker)
	Globals.enemy_spawned.emit()
	
	queue_free()


func _on_grow_timer_timeout():
	grow_level += 1
	match grow_level:
		2:
			ask_for_resource()
		3:
			stage += 1
			$AnimatedSprite2D.play("growth")
			$RotTimer.start($RotTimer.time_left + 25)
			$GrowTimer.start(grow_time)
		4:
			ask_for_resource()
		5:
			ask_for_resource()
		6:
			stage += 1
			$AnimatedSprite2D.play("harvest")
			$RotTimer.start($RotTimer.time_left + 25)
			$PopupBackground/Popup.play("harvest")
			$AnimationPlayer.play("pop_in")
			interaction_active = true
			set_process_input(true)
		
	

func harvest():
	match plant:
		Globals.Plants.PUMPKIN:
			Globals.hud_reference.add_plant(plant, 2)
		Globals.Plants.CARROT:
			Globals.hud_reference.add_plant(plant, 3)
		Globals.Plants.HEART:
			Globals.hud_reference.add_plant(plant, 1)
	# Award score
	Globals.add_score(50)
	queue_free()

func _on_animated_sprite_2d_animation_changed():
	# Frame 0 = empty, 1 = pumpkin, etc.... according to Globals.Plants enum
	$AnimatedSprite2D.frame = plant
