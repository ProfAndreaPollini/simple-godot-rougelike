extends KinematicBody2D

var Blood = preload("res://Scenes/Blood.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var last_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	last_pos = global_position
	$States.active = true
	$States.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(Vector2.ZERO,true,true,true)
	if collision:
		print(collision)
		if collision.collider.is_in_group("weapons"):
			print("hit by ", collision.collider)
			var blood = Blood.instance()
			
			
			
			# move on hit
			var d  = global_position - collision.collider.global_position
			#global_position  =  global_position + d
			#print("normal = ",collision.normal)
			move_and_collide(5*collision.normal*20)
			
				
			blood.global_position = global_position
			var dir = (global_position - collision.collider.global_position).normalized()
			blood.process_material.direction = Vector3(dir.x,dir.y,0)
			get_node("/root/Game").add_child(blood)
			blood.emitting = true
	if last_pos != global_position:
		last_pos = global_position
		print(last_pos)

func _on_Sensing_body_entered(body):
	if body.is_in_group("hero"):
		$States._change_state('Attack')
		print("Hero is near!")


func _on_Sensing_body_exited(body):
	if body.is_in_group("hero"):
		print("Hero is not near!")
