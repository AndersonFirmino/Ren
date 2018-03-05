## This is in-game gui example for Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends Panel


onready var NameLabel = $VBox/Label
onready var DialogText = $VBox/Dialog
onready var CharacterAvatar = $ViewportContainer/CharaterAvatar

var avatar_path = ""
var avatar
var _type
var t
var typing=false

func _ready():
	Ren.connect("enter_statement", self, "_on_statement")
	$Timer.connect("timeout", self, "_on_timeout")

func _on_timeout():
	set_process_unhandled_input(_type == "say")
	
func _input(event):
	if event.is_action_pressed("ren_forward"):
		Ren.rolling_back = false
		if Ren.history_id > 1:
			Ren.history_id -= 1

		if typing: #if typing complete it
			typing=false
		else:      #else exit statement
			Ren.emit_signal("exit_statement", {})

func _on_statement(id, type, kwargs):
	set_process(false)
	_type = type
	$Timer.start()
	if not _type in ["say", "input", "menu"]:
		return

	if "how" in kwargs:
		NameLabel.bbcode_text = kwargs.how
	
	if "what" in kwargs:
		if kwargs.has("speed"):
			writeDialog(kwargs.what, kwargs.speed)
		else:
			writeDialog(kwargs.what)
		

	if "avatar" in kwargs:
		if avatar_path != kwargs.avatar:
			if avatar != null:
				avatar.free()
				
		if kwargs.avatar != null:
			avatar_path = kwargs.avatar
			avatar = load(kwargs.avatar).instance()
			CharacterAvatar.add_child(avatar) 

	return
	
	
func writeDialog(text, speed=0.005):
    #create a timer to print text like a typewriter
	if t != null:
		t.free()
	
	if speed == 0:
		DialogText.bbcode_text=text
		return
	
	typing=true
	DialogText.bbcode_text = ""
	var te=""
	t = Timer.new()
	t.set_wait_time(speed)
	t.set_one_shot(true)
	self.add_child(t)
	
	for letter in text:
		t.start()
		te+=letter
		DialogText.bbcode_text=te
		yield(t, "timeout")
		if !typing:
			DialogText.bbcode_text=text
			break


func _on_Adv_gui_input(ev):
	if ev is InputEventMouseButton:
		var event=InputEventAction.new()
		event.action="ren_forward"
		event.pressed=true
		Input.parse_input_event(event)
