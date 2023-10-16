extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_plant(plant, amount = 1):
	Globals.inv[plant] += amount
	match plant:
		Globals.Plants.PUMPKIN:
			$pumpkin_amount.text = " " + str(Globals.inv[plant])
		Globals.Plants.CARROT:
			$carrot_amount.text = " " + str(Globals.inv[plant])
		Globals.Plants.HEART:
			$bleeding_heart_amount.text = " " + str(Globals.inv[plant])

func remove_plant(plant, amount = 1):
	Globals.inv[plant] -= amount
	match plant:
		Globals.Plants.PUMPKIN:
			$pumpkin_amount.text = " " + str(Globals.inv[plant])
		Globals.Plants.CARROT:
			$carrot_amount.text = " " + str(Globals.inv[plant])
		Globals.Plants.HEART:
			$bleeding_heart_amount.text = " " + str(Globals.inv[plant])
