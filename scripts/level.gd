extends Node2D

@export var composter: PackedScene
@export var water_tap: PackedScene
@export var plant: PackedScene

var rng = RandomNumberGenerator.new()

@onready var gravestones
@onready var replace_graves

@onready var plant_markers

@onready var plant_spawn_time
var plant_spawn_curve = preload("res://resources/spawn_curve.tres")

var time = 0
var time_sum = time

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all gravestones
	gravestones = get_tree().get_nodes_in_group("gravestones")
	replace_graves = []
	for grave in gravestones:
		# Get all the graves to replace
		if grave.replace_me:
			replace_graves.append(grave)
	# Pick random composter replacement grave
	var random_grave_index = rng.randi_range(0, len(replace_graves) - 1)
	var random_composter_grave = replace_graves[random_grave_index]
	# Add new composter
	var new_composter = composter.instantiate()
	add_child(new_composter)
	new_composter.global_position = random_composter_grave.global_position
	new_composter.block_graves.connect(spawn_water_tap)
	# Remove old gravestone
	replace_graves.remove_at(random_grave_index)
	gravestones.erase(random_composter_grave)
	random_composter_grave.queue_free()
	
	# Get plant spawn points 'markers'
	plant_markers = get_tree().get_nodes_in_group("plant_markers")
	
	# Setup & Reset game variables
	plant_spawn_time = 15
	Globals.inv = {Globals.Plants.PUMPKIN: 0, Globals.Plants.CARROT: 0, Globals.Plants.HEART: 0}
	Globals.score = 0
	
	time = 0
	
	Globals.hud_reference.update_inventory()
	Globals.hud_reference.update_score()
	get_tree().paused = false
	
	Globals.enemy_died.connect(on_enemy_died)
	Globals.enemy_spawned.connect(on_enemy_spawned)
	

func spawn_water_tap(blocked_graves):
	# Check for blocked graves by composter
	for grave in blocked_graves:
		replace_graves.erase(grave)
	# Pick random water tap replacement grave
	var random_grave_index = rng.randi_range(0, len(replace_graves) - 1)
	var random_water_tap_grave = replace_graves[random_grave_index]
	# Add new water tap
	var new_water_tap = water_tap.instantiate()
	add_child(new_water_tap)
	new_water_tap.global_position = random_water_tap_grave.global_position
	# Remove old gravestone
	replace_graves.remove_at(random_grave_index)
	gravestones.erase(random_water_tap_grave)
	random_water_tap_grave.queue_free()

func spawn_plant():
	# Get random plant spawn point
	if plant_markers == []:
		# No more positions left to spawn
		return
	var new_plant_marker = plant_markers[randi_range(0, len(plant_markers) - 1)]
	# Create new random plant from options at random position
	var new_plant = plant.instantiate()
	new_plant.position = new_plant_marker.position
	new_plant.plant_marker = new_plant_marker
	new_plant.freed.connect(plant_freed)
	call_deferred("add_child", new_plant)
	# Remove position from list
	plant_markers.erase(new_plant_marker)

func plant_freed(marker):
	plant_markers.append(marker)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Score each second
	time += delta
	time_sum += delta
	if time >= 5.0:
		time -= 5
		# Award score
		Globals.add_score(5)


func _on_plant_spawn_timer_timeout():
	spawn_plant()
	var plant_spawn_factor = time_sum / 600 # Increase spawn rates along a curve for 10 minutes
	plant_spawn_factor = clampf(plant_spawn_factor, 0, 1)
	$PlantSpawnTimer.start(plant_spawn_time * plant_spawn_curve.sample(plant_spawn_factor))
	
func on_enemy_spawned():
	if len(get_tree().get_nodes_in_group("enemies")) == 3:
		$MusicChill.stop()
		$MusicAggressive.play()

func on_enemy_died():
	if len(get_tree().get_nodes_in_group("enemies")) == 3:
		$MusicAggressive.stop()
		$MusicChill.play()
