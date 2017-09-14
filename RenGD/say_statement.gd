## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##
## Say class statement ##

extends "res://RenGD/statement.gd"

###						###
###	Text Passer	import	###
###						###

const REN_TXT = preload("ren_text.gd")
onready var ren_txt = REN_TXT.new()

func text_passer(text = ""):
	## passer for renpy markup format
	## its retrun bbcode
	return ren_txt.text_passer(ren.vars, text)

###							###
###	Say statement class		###
###							###

type = "say"
_kwargs = {"how":"", "what":""}

func use():
    
    if how in _kwargs:
		if _kwargs.how.type == "Character":
			how = _kwargs.how.value
			
			var nhow = ""
			
			if how.name != ("" or null):
				nhow = "{color=" + how.color + "}"
				nhow += how.name
				nhow += "{/color}"
			
			    what = how.what_prefix + what + how.what_suffix
            
            _kwargs.how = nhow
            _kwargs.how = text_passer(_kwargs.how)

            if not kind in _kwargs:
                _kwargs.kind = _kwargs.how.value.kind
    
    if what in _kwargs:
	    _kwargs.what = text_passer(_kwargs.what)

	.use()
	
	set_process_input(true) ## move to gui

## move to gui
func _input(event):
    if event.is_action_released("ren_rollforward"):
		next()

func next():
	set_process_input(false) ## move to gui
	.next()

func debug():
	.debug(["how", "what"])