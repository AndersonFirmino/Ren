## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## Ren <-> Godot code connection class ##

extends Node

onready var ren	= get_node("/root/Window")

const _GDS = preload("gds_passer.gd")
var gds = _GDS.new()
var n = null
var gdscript = null


## execute gdscript code with ren tricks
## possible types: "code", "retrun", "code_block"
func exec(code, type = "retrun"):
	code = gds.gds_passer(code, ren.values)

	var script = "extends Node\n"
	script += "onready var ren = get_node('/root/Window')\n"
	script += "func exec():\n"

	if type == "return":
		script += "\treturn " + code
	
	elif type == "code":
		script += "\t" + code
	
	elif type == "code_block":
		
		var code_block = code.split("\n")
		
		for c in code_block:
			script += "\t" + c + "\n"
	
	else:
		print("unsupported code")
		return

	# print(script)
	
	n = Node.new()
	gdscript = GDScript.new()
	gdscript.set_source_code(script)
	gdscript.reload()
	n.set_script(gdscript)
	add_child(n)
	var ret_val = n.exec()
	remove_child(n)
	return ret_val

