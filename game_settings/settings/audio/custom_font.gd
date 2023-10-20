@tool
extends ggsSetting

var hud_label_settings = preload("res://resources/UI/hud_label_settings.tres")
var hud2_label_settings = preload("res://resources/UI/hud2_label_settings.tres")
var help_label_settings = preload("res://resources/UI/help_label_settings.tres")
var custom_font = preload("res://fonts/static/PixelifySans-Bold.ttf")

func apply(value: Variant) -> void:
	if value:
		hud_label_settings.font = custom_font
		hud2_label_settings.font = custom_font
		help_label_settings.font = custom_font
	else:
		hud_label_settings.font = null
		hud2_label_settings.font = custom_font
		help_label_settings.font = null
