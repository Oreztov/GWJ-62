extends Node2D

var explode_time = 1 # speed_scale factor
var damage = 50
var parent = null
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.speed_scale = explode_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"prepare":
			$AnimationPlayer.speed_scale = 1
			$AnimationPlayer.play("explode")
		"explode":
			queue_free()


func _on_area_2d_area_entered(area):
	# true parent is player, false parent is enemy
	if parent == true:
		if area.is_in_group("enemies"):
			# Do damage
			area.get_parent().take_damage(damage)
		elif area.is_in_group("players"):
			# Ignore player
			return 0
	elif parent == false:
		if area.is_in_group("player"):
			# Do damage
			Globals.player_reference.attacked(damage)
		elif area.is_in_group("enemies"):
			# Ignore player
			return 0
