## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## Main Ren class ##

extends Node

var statements = []
var history = []
var current_statement
var current_statement_id = -1
var current_local_statement_id = -1
var current_block
var current_menu
var choice_id = -1
var values = {"version":{"type":"text", "value":"0.5.0"}}
var using_passer = false
export(bool) var debug_inti = true

const _DEF	= preload("def.gd")
const _CHR	= preload("character.gd")
const _SAY	= preload("say_statement.gd")
const _INP	= preload("input_statement.gd")
const _JMP	= preload("jump_statement.gd")
const _MENU	= preload("menu_statement.gd")
const _CHO	= preload("choice_statement.gd")
const _IF	= preload("if_statement.gd")
const _ELIF	= preload("elif_statement.gd")
const _ELSE	= preload("else_statement.gd")
const _GL	= preload("gd_statement.gd")
const _GB	= preload("godot_statement.gd")
const _SH	= preload("show_statement.gd")
const _HI	= preload("hide_statement.gd")

onready var godot = $GodotConnect

var _def = _DEF.new()

signal enter_statement(type, kwargs)
signal enter_block(kwargs)
signal exit_statement(kwargs)

# add global value that ren will see
func define(val_name, value = null):
	_def.define(values, val_name, value)

# crate new charater as global value that ren will see
# possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
func character(val_name, kwargs):
	var new_ch = _CHR.new()
	new_ch.set_kwargs(kwargs)
	_def.define(values, val_name, new_ch, "character")

# crate new link to node as global value that ren will see
func node_link(node):
	if typeof(node) == TYPE_NODE_PATH:
		_def.define(values, node.name, node)
		
	else:
		_def.define(values, node.name, node, "node")

func _init_statement(statement, kwargs, condition_statement = null):
	statement.ren = self
	statement.set_kwargs(kwargs)
	
	if debug_inti:
		statement.debug(statement.kws, "condition_statement: " + str(condition_statement) + ", ")
		
	if condition_statement != null:
		current_block = condition_statement
		statement.condition_statement = condition_statement
		
		if condition_statement.type == "menu":
			current_local_statement_id = -1
			choice_id += 1
			statement.id = choice_id
			condition_statement.choices.append(statement)
		
		elif condition_statement.type == "_if":
			if statement.type == "_elif":
				condition_statement.conditions.append(statement)
				
			elif statement.type == "_else":
				condition_statement.el = statement
			
			else:
				condition_statement.statements.append(statement)
			

		else:
			condition_statement.statements.append(statement)
		
		choice_id = -1
		current_local_statement_id += 1
		statement.id = current_local_statement_id
	
	else:
		choice_id = -1
		current_local_statement_id = -1
		current_statement_id += 1
		statement.id = current_statement_id
		statements.append(statement)

	return statement

## create statement of type say
## its make given character(how) talk (what)
## with keywords : how, what
func say(kwargs, condition_statement = null):
	if not ("how" in kwargs):
		kwargs["how"] = ""
	return _init_statement(_SAY.new(), kwargs, condition_statement)

## crate statement of type input
## its allow player to provide keybord input that will be assain to given value
## with keywords : how, what, input_value, value
func input(kwargs, condition_statement = null):
	if not ("how" in kwargs):
		kwargs["how"] = ""
	return _init_statement(_INP.new(), kwargs, condition_statement)

## crate statement of type menu
## its allow player to make choice
## with keywords : how, what, title
func menu(kwargs, condition_statement = null):
	var title = null
	if "title" in kwargs:
		title = kwargs.title
		kwargs.erase("title")

	return _init_statement(_MENU.new(title), kwargs, condition_statement)

## crate statement of type choice
## its add this choice to menu
## with keywords : how, what
func choice(kwargs, menu):
	return _init_statement(_CHO.new(), kwargs, menu)

## create statement of type jump
## with keywords : dialog, statement_id
func jump(kwargs, condition_statement = null):
	return _init_statement(_JMP.new(), kwargs, condition_statement)

## create statement of type if
func if_statement(condition, condition_statement = null):
	return _init_statement(_IF.new(condition), {}, condition_statement)

## create statement of type elif
func elif_statement(condition, condition_statement = null):
	return _init_statement(_ELIF.new(condition), {}, condition_statement)

## create statement of type else
func else_statement(condition_statement = null):
	return _init_statement(_ELSE.new(), {}, condition_statement)

## create statement of type gd
## its execute godot one line code
func gd(code, condition_statement = null):
	return _init_statement(_GL.new(code), {}, condition_statement)

## create statement of type godot
## its execute block of godot code
func gd_block(code_block, condition_statement = null):
	return _init_statement(_GB.new(code_block), {}, condition_statement)

## create statement of type show
## with keywords : x, y, z, at, pos, camera
## x, y and pos will use it as procent of screen if between 0 and 1
## "at" is lists that can have: "top", "center", "bottom", "right", "left"
func show(node, kwargs, condition_statement = null):
	if not ("at" in kwargs):
		kwargs["at"] = ["center", "bottom"]
	return _init_statement(_SH.new(node), kwargs, condition_statement)

## create statement of type hide
func hide(node, condition_statement = null):
	return _init_statement(_HI.new(node), {}, condition_statement)


## it starts current ren dialog
func start():
	current_block = []
	current_menu = []
	current_statement_id = 0
	current_local_statement_id = -1
	choice_id = -1
	using_passer = false
	statements[0].enter()
	set_meta("playing",true) # for checking if ren is playing


