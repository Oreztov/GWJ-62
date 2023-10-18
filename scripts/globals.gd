extends Node

enum Resources {
	EMPTY, COMPOST, WATER, SOUL
}

enum Plants {
	EMPTY, PUMPKIN, CARROT, HEART
}

var ingame = false

var inv = {Plants.PUMPKIN: 0, Plants.CARROT: 0, Plants.HEART: 0}

@onready var player_reference: CharacterBody2D
@onready var hud_reference

var debug_plants = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
