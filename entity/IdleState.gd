extends "res://utils/State.gd"


onready var entity = get_parent().get_parent()

func _ready():
	set_physics_process(false)
	set_process(false)
	set_process_input(false)


func enter():
	print("enter IDLE: ", entity.get_name())
	
	return

func exit():
	print("exit IDLE: ", entity.get_name())
	return

func handle_input(event):
	return

func update(delta):
	return

func _on_animation_finished(anim_name):
	return
