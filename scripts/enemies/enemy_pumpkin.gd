extends "res://scripts/enemies/enemy.gd"

@export var weapon_pumpkin: PackedScene



func spawn_weapon_pumpkin():
	var new_pumpkin = weapon_pumpkin.instantiate()
	new_pumpkin.position = position
	new_pumpkin.parent = false
	new_pumpkin.pumpkin_visible = false
	new_pumpkin.scale *= 1.5
	get_parent().call_deferred("add_child", new_pumpkin)

func attack():
	# Start attack, activate hitbox
	if deter:
		$TopPart.play("deter_attack_stage1")
		$BottomPart.play("deter_attack_stage1")
	else:
		$TopPart.play("attack_stage1")
		$BottomPart.play("attack_stage1")
	attacking = true
	allowed_to_move = true

func _on_hitbox_area_body_entered(body):
	if body.is_in_group("player") and not attacking:
		attack()


func _on_top_part_animation_finished():
	# Stage 1 done
	if $TopPart.animation == "attack_stage1" or $TopPart.animation == "deter_attack_stage1":
		if deter:
			$TopPart.play("deter_attack_stage2")
			$BottomPart.play("deter_attack_stage2")
		else:
			$TopPart.play("attack_stage2")
			$BottomPart.play("attack_stage2")
		allowed_to_move = false
		spawn_weapon_pumpkin()
	# Stage 2 done
	elif $TopPart.animation == "attack_stage2" or $TopPart.animation == "deter_attack_stage2":
		queue_free()
	
func _on_attack_area_area_entered(area):
	if area.is_in_group("player") and not attacking:
		attack()

func _on_top_part_frame_changed():
	pass
