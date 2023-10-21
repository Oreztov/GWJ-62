extends Node

enum Resources {
	EMPTY, COMPOST, WATER, SOUL
}

enum Plants {
	EMPTY, PUMPKIN, CARROT, HEART
}

var ingame = false

var inv = {Plants.PUMPKIN: 0, Plants.CARROT: 0, Plants.HEART: 0}
var score = 0

@onready var player_reference: CharacterBody2D
@onready var hud_reference

@onready var colorblind_reference
var colorblind_mode
var colorblind_intensity

var debug_plants = []

signal hotkeys_updated
signal game_over

signal enemy_spawned
signal enemy_died

func _ready():
	game_over.connect(save_data)

func add_score(amount):
	score += amount
	hud_reference.update_score()
	
func save_data():
	if score > SaveSystem.get_var("high_score", 0):
		SaveSystem.set_var("high_score", score)
		SaveSystem.save()
	
	
