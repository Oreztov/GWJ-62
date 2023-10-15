extends CharacterBody2D


@export var speed = 10
@onready var nav_agent = $NavNode/NavigationAgent2D


func ready():
	pass

func _physics_process(delta):
	var direction = to_local(nav_agent.get_next_path_position())
	velocity = direction * speed
	move_and_slide()
	
func find_path():
	nav_agent.target_position = Globals.player_reference.global_position

func _on_nav_update_timer_timeout():
	find_path()
