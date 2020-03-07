extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var states: Dictionary = {}
var states_stack = []
var current_state = null
export(bool) var active = false setget set_active



# Called when the node enters the scene tree for the first time.
func _ready():
	for state in get_children():
		state.connect('finished',self,"_on_change_state")
		states[state.state_name.to_upper()] = state
		
	
	states_stack.push_front(get_child(0))
	current_state = states_stack[0]
	if active:
		start()

func start():
	current_state.enter()
	set_active(true)

func set_active(value):
	active = value
	set_physics_process(value)
	set_process_input(value)
	if not active:
		states_stack = []
		current_state = null

func _unhandled_input(event):
	current_state.handle_input(event)

func _physics_process(delta):
	current_state.update(delta)

func _on_animation_finished(anim_name):
	if not active:
		return
	current_state._on_animation_finished(anim_name)

func _change_state(state_name):
	if not active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states[state_name]
	print("CHANGE STATE: ",current_state.state_name, " -> ",states_stack[0].state_name)
	current_state = states_stack[0]
	emit_signal("state_changed", current_state)
	current_state.enter()


func _on_Sensing_body_entered(body):
	if body.is_in_group("hero"):
		_change_state('ATTACK')


func _on_Sensing_body_exited(body):
	if body.is_in_group("hero"):
		_change_state('IDLE')
