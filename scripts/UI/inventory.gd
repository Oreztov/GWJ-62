extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get hotkeys
	var interact_key
	for action in InputMap.action_get_events("use_pumpkin"):
		interact_key = action.as_text().split(" ")[0]
	$pumpkin_hotkey.text = $pumpkin_hotkey.text % interact_key
	
	for action in InputMap.action_get_events("use_carrot"):
		interact_key = action.as_text().split(" ")[0]
	$carrot_hotkey.text = $carrot_hotkey.text % interact_key
	
	for action in InputMap.action_get_events("use_heart"):
		interact_key = action.as_text().split(" ")[0]
	$bleeding_heart_hotkey.text = $bleeding_heart_hotkey.text % interact_key
	
	update_inventory()


func update_inventory():
		$pumpkin_amount.text = " " + str(Globals.inv[Globals.Plants.PUMPKIN])
		$carrot_amount.text = " " + str(Globals.inv[Globals.Plants.CARROT])
		$bleeding_heart_amount.text = " " + str(Globals.inv[Globals.Plants.HEART])

func add_plant(plant, amount = 1):
	Globals.inv[plant] += amount
	update_inventory()

func remove_plant(plant, amount = 1):
	Globals.inv[plant] -= amount
	update_inventory()
			
