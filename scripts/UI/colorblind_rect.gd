extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.colorblind_reference = self
	if not OS.has_feature("web"):
		update()

func update():
	material.set_shader_parameter("mode", Globals.colorblind_mode)
	material.set_shader_parameter("intensity", Globals.colorblind_intensity)
