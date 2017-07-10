## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Node

## it's how import rengd framework when res://scenes/gui/Window.tscn is loaded as singleton
onready var ren = get_node("/root/Window")

func do_dialog():
	## This must be at end of ren's dialog
	ren.do_dialog()


func define(key_name, key_value = null):
	## add global var that ren will see
	ren.define(key_name, key_value)


func Character(name = "", color = "", what_prefix = "", what_suffix = "", kind = "adv"):
	## return new Character
	return ren.Character(name, color, what_prefix, what_suffix, kind)


func dialog(dialog_name, scene_path, node_path = "", func_name = ""):
	## this declare new dialog
	## that make ren see dialog and can jump to it
	ren.dialog(dialog_name, scene_path, node_path, func_name)


func set_current_dialog(dialog):
	## this is need to be done in game first dialog
	ren.set_current_dialog(dialog)


func jump(dialog_name, args = []):
	## go to other declared dialog
	ren.jump(dialog_name, args)
	

func say(how, what):
	## append say statement
	ren.append_say(how, what)


func input(ivar, what, temp = ""):
	## append input statement
	ren.append_input(ivar, what, temp)


func before_menu():
	## must be on begin of menu custom func
	ren.before_menu()


func after_menu():
	## must be on end of menu custom func
	ren.after_menu()


func menu(choices, title = "", node = null, func_name = ""):
	## append menu_func statement
	ren.append_menu(choices, title, node, func_name)


func node(node_name, node_path, subnode = false):
	## asign a global ren name for given node
	ren.node(node_name, node_path)


func auto_subnodes(node_name, node_path, name_of_node_to_skip = ""):
	## asign a global ren name for given node
	ren.auto_subnodes(node_name, node_path, name_of_node_to_skip)


func ren_show(node_to_show):
	## append show statement
	ren.append_show(node_to_show)
	

func ren_hide(node_to_hide):
	## append hide statement
	ren.append_hide(node_to_hide)

	
