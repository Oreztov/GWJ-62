extends StaticBody2D

signal block_graves(bodies)

var blocked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	var blocked_graves = $BlockArea.get_overlapping_bodies()
	if not blocked and blocked_graves != []:
		block_graves.emit(blocked_graves)
		blocked = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.set_hand_item(Globals.Resources.COMPOST)
