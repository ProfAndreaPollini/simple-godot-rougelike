extends KinematicBody2D

var Blood = preload("res://Scenes/Blood.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var last_pos
var is_hit

const HIT_TIME = 0.4
var hit_time_left = HIT_TIME

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	last_pos = global_position
	$States.active = true
	$States.start()
	
	is_hit = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hit_time_left >0:
		hit_time_left-= delta
		return
	else:
		is_hit = false
	var collision = move_and_collide(Vector2.ZERO,true,true,true)
	if collision:
		
		if collision.collider.is_in_group("weapons"):
			# entity colides with a weapon
			print("hit by ", collision.collider)
			is_hit = true
			hit_time_left = HIT_TIME
			var blood = Blood.instance()
			
			## entity damage ui display
			Events.emit_signal("hit",self)
			
			#damage_ui.start()
			
			# move on hit
			var d  = global_position - collision.collider.global_position
			#global_position  =  global_position + d
			print("normal = ",collision.normal, " ",global_position)
			#move_and_collide(5*collision.normal*20)
			
			## TODO: RESOLVE MOVEMENT AFTER HIT
			var c = move_and_collide(collision.normal*30)
			
			if c and not c.collider.is_in_group("weapons"):
				print("colliding with: ",c.collider.get_name())
				global_position = c.position
			elif c and  c.collider.get_name() == "map":
				global_position = collision.position
			if c and c.collider.is_in_group("weapons"):
				print("colliding with weapon: ",c.collider.get_name())
				#global_position += 5*collision.normal*20
			#else:
		#		print("else")
			#	global_position += 5*collision.normal*20
			print("pos = ",global_position)
			
			blood.global_position = global_position
			var dir = (global_position - collision.collider.global_position).normalized()
			blood.process_material.direction = Vector3(dir.x,dir.y,0)
			get_node("/root/Game").add_child(blood)
			blood.emitting = true
		#	yield(get_tree().create_timer(1), "timeout")
		#	is_hit = false
			
			print("hit done")
			
	if last_pos != global_position:
		last_pos = global_position
		#print(last_pos)

func _on_Sensing_body_entered(body):
	if body.is_in_group("hero"):
		$States._change_state('Attack')
		print("Hero is near!")


func _on_Sensing_body_exited(body):
	if body.is_in_group("hero"):
		print("Hero is not near!")
