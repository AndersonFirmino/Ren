tool
extends VisualScriptCustomNode

export var choices = 1 setget set_choices
export var allow_back = true
func set_choices(nc):
	choices=nc
	emit_signal("ports_changed")

func _get_caption():
	return "Ask"
	
func _get_input_value_port_count():
	return choices+2
func _get_input_value_port_type(idx):
	return TYPE_STRING
func _get_input_value_port_name(idx):
	if idx==0:
		return "char id"
	elif idx==1:
		return "Question"
	else:
		return "Choice "+str(idx-1)
func _has_input_sequence_port():
	return true
	
func _get_output_sequence_port_count():
	return choices

func _get_working_memory_size():
	return 1

func _get_output_value_port_count():
	return 0
func _get_output_sequence_port_text(idx):
	return "On Choice "+str(idx+1)

func _step(inputs, outputs, start_mode, working_mem):
	#ADD IN LIST
	
	var Ren = Engine.get_main_loop().root.get_node("Ren")
	var obj=Ren.values
	if obj.has("RenVS"):
		if not(self in obj["RenVS"]["value"]):
			obj["RenVS"]["value"].append(self)
		else:
			print("is in list")
			allow_back=false
	else:
		var arr=Array()
		arr.append(self)
		Ren.define("RenVS",[self])
	if self.get_instance_id() in Ren.vnl:
		print(inputs[1],"already there")
		allow_back=false
	else:
		print(inputs[1],"added")
		Ren.vnl.append(self.get_instance_id())
	#LODING
	if Ren.vis_loading:
		if Ren.history_vis.size()>Ren.load_counter:
			var m=Ren.menu({"who":inputs[0],"what":inputs[1]})
			if Ren.history_vis[Ren.load_counter]==-1:
				Ren.load_counter+=1
				return 0 | STEP_GO_BACK_BIT
			else:
				Ren.load_counter+=1
				if not(get_instance_id() in Ren.vnl):
					print(self.get_instance_id(),"vnl is : { ",Ren.vnl,"}")
					return Ren.history_vis[Ren.load_counter-1] | STEP_PUSH_STACK_BIT
				else:
					return Ren.history_vis[Ren.load_counter-1]
	

	var kwargs=[]
	
	if start_mode==START_MODE_CONTINUE_SEQUENCE and Ren.get_meta("go_back")==false:
		return 0 
	if start_mode==START_MODE_BEGIN_SEQUENCE or start_mode==START_MODE_CONTINUE_SEQUENCE:
		var m=Ren.menu({"who":inputs[0],"what":inputs[1]})
		for x in range(choices):
			var c=Ren.choice({"what":inputs[x+2]},m)
			#Ren.say({"who":inputs[0],"what":""},c)
		if !Ren.get_meta("playing"):
			Ren.start()
		else:
			Ren.statements[Ren.current_statement_id].exec()
		var n= VisualScriptFunctionState.new()
		#n.connect_to_signal(Engine.get_main_loop(),"idle_frame",[])
		n.connect_to_signal(Ren,"enter_block",kwargs)
		working_mem[0]=n
		print(n)
		return 0 | STEP_YIELD_BIT
	elif start_mode==START_MODE_RESUME_YIELD:
		#print("got choice ",Ren.get_meta("last_choice"))
		print("push or next")
		if Ren.get_meta("quitcurrent")==true:
			return 0 | STEP_NO_ADVANCE_BIT
		if Ren.get_meta("go_back"):
			print("push bback")
			#Ren.statements.pop_back()
			#Ren.statements.pop_back()
			Ren.history_vis.append(-1)
			return 0 | STEP_GO_BACK_BIT
		else:
			if allow_back:
				Ren.history_vis.append(Ren.get_meta("last_choice"))
				return Ren.get_meta("last_choice") | STEP_PUSH_STACK_BIT
			else:
				Ren.history_vis.append(Ren.get_meta("last_choice"))
				return Ren.get_meta("last_choice")