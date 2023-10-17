extends "res://scripts/enemies/enemy.gd"

func handle_movement():
	var direction = (Globals.player_reference.position - position).normalized()
	return direction * speed
