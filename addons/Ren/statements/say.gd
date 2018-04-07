extends "statement.gd"


func _init():
	type = "say"
	kws = ["who", "what"]

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "who" in kwargs:
		if kwargs.who in Ren.values:
			if Ren.get_value_type(kwargs.who) == "character":
				var org_who = kwargs.who
				var who = Ren.get_value(org_who)
				kwargs.who = who.parse_character()
				
				if "avatar" in Ren.get_value(org_who).kwargs:
					kwargs["avatar"] = Ren.get_value(org_who).avatar
				
				if "what" in kwargs:
					kwargs.what = who.parse_what(kwargs.what)
	
	if "who" in kwargs:
		kwargs.who = Ren.text_passer(kwargs.who)
	
	if "what" in kwargs:
		kwargs.what = Ren.text_passer(kwargs.what)
	
	.exec(false)

func add_to_history(_type):
	var s = {"type":_type, "kwargs":kwargs}
	var id = str(Ren.current_id)
	if not(id in Ren.history):
		Ren.history[id] = {}

	var hi_item = Ren.history[str(id)]
	hi_item["statement"] = s
	Ren.current_id +=1
	# print(id, ": ", Ren.story_state, ": ", s)


func on_exit(_type, new_kwargs = {}):
	if !setup_exit(_type, new_kwargs):
		return
	
	add_to_history(_type)

	Ren.story_step()
	
	