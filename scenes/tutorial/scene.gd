## This is Ren'GD tutorial script ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends "res://scripts/RenGD/ren_short.gd"

var tscn_path = get_tree().get_root().tscn_path

func _ready():
	label("scene", tscn_path, get_path_to(self), 'scene')


func scene():
	pass

	
