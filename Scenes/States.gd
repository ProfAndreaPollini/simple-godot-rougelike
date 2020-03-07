extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for state in get_children():
		states[state.state_name] = state
	print(states)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
