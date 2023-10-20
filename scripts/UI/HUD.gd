extends CanvasLayer

var initial_score_text

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.hud_reference = self
	
	initial_score_text = $ScoreLabel.text
	
	update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_plant(plant, amount = 1):
	$inventory.add_plant(plant, amount)

func remove_plant(plant, amount = 1):
	$inventory.remove_plant(plant, amount)
	
func update_inventory():
	$inventory.update_inventory()

func add_hp(health):
	$hp.add_hp(health)

func sub_hp(health):
	$hp.sub_hp(health)

func get_hp():
	return $hp.get_hp()
	
func update_score():
	$ScoreLabel.text = initial_score_text % Globals.score
	
