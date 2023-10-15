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

var rng = RandomNumberGenerator.new()

signal freed(marker)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Pick random plant type
	plant = randi_range(1, Globals.Plants.size() - 1)
	$Popup.visible = false
	$AnimatedSprite2D.play("sprout")
	$AnimatedSprite2D.frame = plant

func ask_for_resource():
	# Get new random resource needed
	var random_resource_index = rng.randi_range(0, len(resources_needed) - 1)
	resource_needed = resources_needed[random_resource_index]
	# Remove resource from list
	resources_needed.remove_at(random_resource_index)
	# Activate Popup
	$Popup.visible = true
	match resource_needed:
		Globals.Resources.WATER:
			$Popup/PopupText.text = "W"
		Globals.Resources.COMPOST:
			$Popup/PopupText.text = "C"
		Globals.Resources.SOUL:
			$Popup/PopupText.text = "S"
	# Activate interaction
	interaction_active = true
	set_process_input(true)

func consume_resource():
	# Restart grow timer and add to rot timer
	$GrowTimer.start(grow_time)
	$RotTimer.start($RotTimer.time_left + 5)
	# Consume player hand item
	Globals.player_reference.set_hand_item(Globals.Resources.EMPTY)
	$Popup.visible = false
	$InteractionLabel.disable()
	resource_needed = Globals.Resources.EMPTY
	# Disable interaction
	interaction_active = false
	player_in_area = false
	set_process_input(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str($RotTimer.time_left)

func _input(event):
	if player_in_area and interaction_active:
		if stage == 3:
			harvest()
		elif event.is_action_pressed("interact") and stage < 3:
			# Check for player holding correct item
			if Globals.player_reference.hand == resource_needed:
				consume_resource()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and interaction_active and stage < 3:
		$InteractionLabel.enable()
		player_in_area = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player") and interaction_active and stage < 3:
		$InteractionLabel.disable()
		player_in_area = false

func _on_rot_timer_timeout():
	freed.emit(plant_marker)
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
			$RotTimer.start($RotTimer.time_left + 15)
			interaction_active = true
			set_process_input(true)
		
	

func harvest():
	queue_free()

func _on_animated_sprite_2d_animation_changed():
	# Frame 0 = empty, 1 = pumpkin, etc.... according to Globals.Plants enum
	$AnimatedSprite2D.frame = plant
