## This is in-game gui example for Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends HBoxContainer

onready var ren = get_node("/root/Window")

func _ready():
	ren.connect("enter_statement", self, "_on_statement")
	$Back.connect("pressed", ren, "rollback")
	$Back.disabled = true
	
	$Auto.connect("pressed", self, "on_auto")
	$AutoTimer.connect("timeout", self, "on_auto_loop")
	
	$Skip.connect("pressed", self, "on_skip")
	$SkipTimer.connect("timeout", self, "on_skip_loop")
	$Skip.disabled = true

	$History.disabled = true

func can_skip():
	if not ren.history.empty():
		if ren.current_statement in ren.history:
			if ren.current_statement != ren.history.back():
				return true
			
	return false

func _on_statement(type, kwargs):
	$Back.disabled = ren.current_statement.id == 0
	$Skip.disabled = !can_skip()
	$History.disabled = ren.history.empty()

func on_auto():
	if not $AutoTimer.is_stopped():
		$AutoTimer.stop()
		return
	
	$AutoTimer.start()

func on_auto_loop():
	if ren.current_statement.type == "say":
		ren.emit_signal("exit_statement", {})

	else:
		$AutoTimer.stop()

func on_skip():
	if not $SkipTimer.is_stopped():
		$SkipTimer.stop()
		return
	
	$SkipTimer.start()

func on_skip_loop():
	if (ren.current_statement.type == "say"
		and ren.current_statement in ren.history):
		ren.emit_signal("exit_statement", {})
	
	else:
		$SkipTimer.stop()

func _input(event):
	if event.is_action("ren_backward"):
		on_rollback()

