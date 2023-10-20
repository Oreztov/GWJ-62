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

func add_score(amount):
	score += amount
	hud_reference.update_score()
	
