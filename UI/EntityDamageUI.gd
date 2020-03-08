extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"





func start():
	#$AnimationPlayer.stop(true)
	$AnimationPlayer.play("flow_up")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	
