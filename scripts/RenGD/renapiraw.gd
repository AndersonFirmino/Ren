
extends Node

# This is Ren'GD API
# version: 0.0.1

var characters = []
var screens = []
var images = []
var vars = {}

func _ready():
  Globals.set("characters", characters)
  Globals.set("screens", screens)
  Globals.set("images", images)
  Globals.set("vars", vars)

func define(var_name, var_value):
  Globals.get("vars")[var_name] = var_value

func _get_var(var_name):
  return Globals.get("vars")[var_name]

func line_passer(text):
  if text.begins_with("$"):
    fun = text.substr(1, spl - 1)
    fun = fun.replace(" ", "")

    args = text.substr(spl + 1, end - 1)
    args = args.split(",")

    for a in args:
      a = str2var(a)

    callv(fun, args)


func str_passer(text):
	var pstr = ""
	var vstr = ""
	var b = false

	var i = 1

	for t in text:

		if t == "[":
			b = true
			pstr += t

		elif t == "]":
			b = false
			pstr += t
			vstr = var2str(_get_var(vstr))
			text = text.replace(pstr, vstr)

		elif b:
			pstr += t
			vstr += t

	text = text.replace("{image", "[img")
	text = text.replace("{", "[")
	text = text.replace("}", "]")

	return text
