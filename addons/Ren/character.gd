## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## Character Class ##

extends "ren_node.gd"

var kwargs = {"name":"", "what_prefix":"", "what_suffix":"", "color":"white"}
var kw = ["name", "color", "what_prefix", "what_suffix", "avatar"]
var _color

export(String) var character_id = "" setget set_character_id, get_character_id
export(String) var character_name = "" setget set_character_name, get_character_name
export(Color) var color = Color("#ffffff") setget set_color, get_color
export(String) var prefix = "" setget set_prefix, get_prefix
export(String) var suffix = "" setget set_suffix, get_suffix
export(PackedScene) var avatar = "" setget set_avatar, get_avatar

func _ready():
	Ren.character(node_id, kwargs, self)
	print("Add Character ", node_id, " with ", kwargs)

func set_character_id(value):
	if node_id != value:
		Ren.values.erase(node_id)
	
	node_id = value
	Ren.character(value, kwargs)

func get_character_id():
	return node_id

func set_character_name(value):
	set_kwargs({"name": value})

func get_character_name():
	return kwargs.name

func set_color(value):
	_color = value
	set_kwargs({"color":value.to_html()})

func get_color():
	return _color

func set_prefix(value):
	set_kwargs({"what_prefix":value})

func get_prefix():
	return kwargs.prefix

func set_suffix(value):
	set_kwargs({"what_suffix":value})

func get_suffix():
	return kwargs.suffix

func set_avatar(value):
	set_kwargs({"avatar":value.resource_path})

func get_avatar():
	return load(kwargs.prefix)

func set_kwargs(new_kwargs):
	# update character
	for kw in new_kwargs:
		kwargs[kw] = new_kwargs[kw]

func parse_character():
	var ncharacter = ""
	
	if "name" in kwargs:
		ncharacter = "{color=#" + kwargs.color + "}"
		ncharacter += kwargs.name
		ncharacter += "{/color}"
	
	return ncharacter

func parse_what(what):
	 return kwargs.what_prefix + what + kwargs.what_suffix

