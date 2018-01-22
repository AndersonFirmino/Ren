## This is RenAPI ##
## version: 0.3.0 ##
## License MIT ##
## Choice class statement ##

extends "say_statement.gd"

var statements = [] # statements after this choice 

func _init():
	._init()
	type = "choice"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	on_enter_block()

func on_enter_block(new_kwargs = {}):
	.on_enter_block(new_kwargs)
	statements[0].enter()

func on_exit(new_kwargs = {}):
	condition_statement.on_exit(new_kwargs)
