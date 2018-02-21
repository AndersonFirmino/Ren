tool
extends VisualScriptCustomNode

func _get_caption():
	return "Input "
	
func _has_input_sequence_port():
	return true

func _get_output_sequence_port_count():
	return 1
	
func _get_input_value_port_count():
	return 4
	
func _get_input_value_port_type(idx):
	return TYPE_STRING
	
func _get_input_value_port_name(idx):
	if idx==0:
		return "char id"
	elif idx==1:
		return "Text "
	elif idx==2:
		return "variable name"
	elif idx==3:
		return "Default"
	
func _get_working_memory_size():
	return 1
func _step(inputs, outputs, start_mode, working_mem):
	var kwargs=[]
	var ren = Engine.get_main_loop().root.get_node("Window")
	#ren.define(inputs[2])
	var s={"how":inputs[0],"what":inputs[1],"input_value":inputs[2],"value":inputs[3]}
	if start_mode==START_MODE_BEGIN_SEQUENCE:
		ren.input(s)
		if !ren.get_meta("playing"):
			ren.start()
		else:
			ren.statements[ren.current_statement_id].enter()
		var n= VisualScriptFunctionState.new()
		#n.connect_to_signal(Engine.get_main_loop(),"idle_frame",[])
		n.connect_to_signal(ren,"exit_statement",kwargs)
		working_mem[0]=n
		print(n)
		return 0 | STEP_YIELD_BIT
	elif start_mode==START_MODE_RESUME_YIELD:
		#print("got choice ",ren.get_meta("last_choice"))
		return 0