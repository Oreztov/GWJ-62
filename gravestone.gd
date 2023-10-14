extends StaticBody2D

@export var replace_me = false

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_sprite = rng.randi_range(0, 4)
	$BottomPart.frame = random_sprite
	$TopPart.frame = random_sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
