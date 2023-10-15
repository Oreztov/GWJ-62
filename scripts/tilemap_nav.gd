extends TileMap

var a_star: AStar2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = self.get_used_rect().size
	a_star = AStar2D.new()
	a_star.reserve_space(size.x * size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
