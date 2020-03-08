extends "res://Scenes/Entity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$sprites.play("idle")

func on_state_changed(from_state, to_state):
	print(">>> change state from ", from_state, " to ",to_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
