extends Node

enum Resources {
	EMPTY, COMPOST, WATER, SOUL
}

enum Plants {
	EMPTY, PUMPKIN, CARROT, HEART
}

@onready var player_reference: CharacterBody2D

var debug_plants = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
