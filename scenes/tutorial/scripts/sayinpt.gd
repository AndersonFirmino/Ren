## This is Ren'GD example say script##

## version: 0.7 ##
## License MIT ##

extends "res://RenGD/ren_short.gd"

var tscn_path

func _ready():
	tscn_path = get_parent().tscn_path
	dialog("say", tscn_path, get_path(), 'dialog_say')
	dialog("input", tscn_path, get_path(), 'dialog_input')


func dialog_say():
	pass


func dialog_input():
	pass
	
