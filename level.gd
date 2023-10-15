extends Node2D

@export var composter: PackedScene
@export var water_tap: PackedScene
@export var plant: PackedScene

var rng = RandomNumberGenerator.new()

@onready var gravestones
@onready var replace_graves

@onready var plant_markers

@onready var plant_spawn_time

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
	
	# Setup game variables
	plant_spawn_time = 5

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
	var new_plant_index = randi_range(0, len(plant_markers) - 1)
	if new_plant_index < 0:
		# No more positions left to spawn
		return
	# Create new plant at random position
	var new_plant = plant.instantiate()
	new_plant.position = plant_markers[new_plant_index].position
	call_deferred("add_child", new_plant)
	# Remove position from list
	plant_markers.remove_at(new_plant_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_plant_spawn_timer_timeout():
	spawn_plant()
	$PlantSpawnTimer.start(plant_spawn_time)
