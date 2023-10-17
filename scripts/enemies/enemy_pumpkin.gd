extends "res://scripts/enemies/enemy.gd"

@export var weapon_pumpkin: PackedScene


func _on_hitbox_area_body_entered(body):
	if body.is_in_group("player"):
		var new_pumpkin = weapon_pumpkin.instantiate()
		# Spawn at legs
		new_pumpkin.position = position + $CollisionShape2D.position
		new_pumpkin.parent = false
		get_parent().call_deferred("add_child", new_pumpkin)
		queue_free()
