extends Node2D

var speed = 250
var damage = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation).normalized()
	position += direction * speed * delta
	

func _on_hitbox_area_area_entered(area):
	if area.is_in_group("enemies"):
		# Do damage
		area.get_parent().take_damage(damage)
		queue_free()
	elif area.is_in_group("players"):
		# Ignore player
		return 0

