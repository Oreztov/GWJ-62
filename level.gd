extends Node2D

@export var composter: PackedScene
@export var water_tap: PackedScene

var rng = RandomNumberGenerator.new()

@onready var gravestones
@onready var replace_graves

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
