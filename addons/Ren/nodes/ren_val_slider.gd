extends Slider

export(String) var val_name = "" 

export(float) var default = 0.5 setget set_default, get_default


func set_default(val):
	default = val
	value = default

func get_default():
	return default

func _ready():
	if val_name in Ren.values:
		default = Ren.get_value(val_name)
	
	else:
		Ren.define(val_name, default)
	
	connect("value_changed", self, "on_slider_val_changed")
	Ren.connect("val_changed", self, "on_val_changed")

func on_val_changed(valn):
	if val_name != valn:
		return
	
	value = Ren.get_value(val_name)

func on_slider_val_changed(val):
	Ren.define(val_name, val)

	
