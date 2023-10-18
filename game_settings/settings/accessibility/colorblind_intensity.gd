@tool
extends ggsSetting


func apply(value: Variant) -> void:
	Globals.colorblind_intensity = value
	if Globals.colorblind_reference:
		Globals.colorblind_reference.update()
