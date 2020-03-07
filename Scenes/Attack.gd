extends "res://utils/State.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const state_name = 'Attack'

var hero
var navigator
var line2d
var path
var me

var v = 30
# Called when the node enters the scene tree for the first time.
func _ready():
	me = get_parent().get_parent()
	set_physics_process(false)
	set_process(false)
	set_process_input(false)
	
	
	



func enter():
	navigator = Events.game.find_node("Navigation2D")#.get_simple_path($heroBody.global_position,$Orc.global_position)
	hero = Events.game.find_node("heroBody")
	line2d = Events.game.find_node("Line2D")
	path = navigator.get_simple_path(me.global_position,hero.global_position,false)

	
	print(hero)
	

func exit():
	$Timer.stop()

func handle_input(event):
	if hero.is_moving && $Timer.is_stopped():
		$Timer.start()
	#if not hero.is_moving && not $Timer.is_stopped():
	#	$Timer.stop()



func update(delta):
	var distance = v * delta
	var start_point = me.global_position
	#for i in range(len(path)):
	var done = false
	while not done && len(path)>0:
		var closest_point = path[0]#navigator.get_closest_point(path)
		var distance_to_next = start_point.distance_to(closest_point)
		if distance	<= distance_to_next and distance >= 0.0:
			me.global_position =start_point.linear_interpolate(closest_point,distance/distance_to_next)
			#path = navigator.get_simple_path(me.global_position,hero.global_position,false)

			break
		elif distance <= 0.0:
			
			#path = navigator.get_simple_path(me.global_position,hero.global_position,false)

			me.global_position = closest_point
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
				 
	
	line2d.points = path

func _on_animation_finished(anim_name):
	return


func _on_Timer_timeout():
	path = navigator.get_simple_path(me.global_position,hero.global_position,false)
