## This is Ren'GD tutorial script ##

## version: 0.1.0 ##
## License MIT ##

extends "res://RenGD/ren_short.gd"

var tscn_path

func _ready():
	tscn_path = get_parent().tscn_path
	dialog("scene", tscn_path, get_path(), 'scene')


func scene():
	pass

	
