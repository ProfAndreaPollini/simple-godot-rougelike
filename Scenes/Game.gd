extends Node2D

var Room = load("res://entity/Room.gd")
var EntityDamageUI = preload("res://UI/EntityDamageUI.tscn")

onready var map = $Navigation2D/map

func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a

func create_rooms_grid(num_rooms):
	var dir = Vector2.ZERO
	var pos = Vector2(int(rand_range(0,level_size.x-1)),int(rand_range(0,level_size.y-1)))
	print("starting from ",pos)
	roomsGrid[pos.y][pos.x] = 1
	num_rooms -= 1
	while num_rooms > 0:
		dir = Vector2.ZERO
		if randf() > 0.5: # dx - sx
			if randf() > 0.5:
				dir += Vector2.RIGHT
			else:
				dir += Vector2.LEFT	
		else:
			if randf() > 0.5:
				dir += Vector2.UP
			else:
				dir += Vector2.DOWN	
		print("evaluating ",pos+dir)
		if pos.y + dir.y >= level_size.y or pos.x + dir.x >= level_size.x or pos.y + dir.y<0 or pos.x + dir.x<0:
			print("NO")
			continue
		if roomsGrid[pos.y + dir.y][pos.x + dir.x] == null:
			pos = pos + dir
			num_rooms -= 1
			roomsGrid[pos.y][pos.x] = 1
			print("ok")
			
func get_adjacent_rooms(room):
	var pos = Vector2(room.x,room.y)
	var adjacents_rooms = []
	for offset in [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]:
		var other_room_pos = pos+offset
		if  other_room_pos.x < 0 or other_room_pos.y < 0 or other_room_pos.x >= level_size.x or other_room_pos.y >= level_size.y:
			adjacents_rooms.append(false)
		else:
			if roomsGrid[other_room_pos.y][other_room_pos.x] != null:
				adjacents_rooms.append(true)
			else:
				adjacents_rooms.append(false)
	return adjacents_rooms
		
		
const room_kind = [
	[true, true, true, true],
	
	[true, false, false, false],
	[false, true, false, false],
	[false, false,true, false],
	[false, false,false,true ],
	
	
	[true, false, true, false],
	[false,true , false, true],
	
	
	[true, true, true, false],
	[true, true, false,true],
	[true, false, true, true],
	[false, true, true, true],
	
	
	[true, true, false, false],
	[false, true, true, false],
	[false, false, true, true],
	[true, false, false, true],
]

const vector_pos_list = [
	[0,1,2,3],
	[1,2,3,0],
	[2,3,0,1],
	[3,0,1,2]
]

func compare_adjacent_rooms(r,k): 
	var rotations = 0
	for p in vector_pos_list:
		if r[p[0]] == k[0] and r[p[1]] == k[1] and r[p[2]] == k[2] and r[p[3]] == k[3]:
			return [true,rotations]
		rotations +=1
	return [false,0]
	
# ritorna un vettore di quattro elementi che corrispondono alle eventuali porte nelle 
# direzioni UP DOWN LEFT RIGHT (false = no porta, true  = porta)
func get_doors_by_room(room):
	var kind = room_kind[room.kind ]
	var variant = vector_pos_list[room.variant]
	return [kind[variant[0]],kind[variant[1]],kind[variant[2]],kind[variant[3]] ]
			
func calc_room_kind():
	for room in rooms:
		var adjacent_rooms = get_adjacent_rooms(room)
		print("ADJACENT ROOMS",adjacent_rooms, " for ",room.x," ",room.y)
#		for i in range(len(room_kind)):
#			var ret = compare_adjacent_rooms(adjacent_rooms,room_kind[i])
#			if ret[0]:
#				print(room,i, " variant = ",ret[1])
		room.kind = adjacent_rooms
		#room.variant = ret[1]
		roomsGrid[room.y][room.x] = room
				
		print(room,get_adjacent_rooms(room))

var roomsGrid
var rooms = []
var level_size 
export var ROOM_SIZE:int = 16
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	Events.game = self
	
	level_size = Vector2(5,5)
	roomsGrid = create_2d_array(level_size.x,level_size.y,null)
	create_rooms_grid(5)
	for y in range(level_size.y):
		for x in range(level_size.x):
			if roomsGrid[y][x] != null:
				$Level.set_cell(x,y,0)
				rooms.append(Room.new(x,y))
	#yield(get_tree().create_timer(2), "timeout")
	#$Animations.play("fade_out_level_intro")
	calc_room_kind()
	for room in rooms:
		print(room.x,' ',room.y,' ', room.kind, ' ', room.variant)
	
	for y in range(level_size.y):
		for x in range(level_size.x):
			if roomsGrid[y][x] != null:
				var current_room = roomsGrid[y][x]
				print(current_room.x," ",current_room.y," - ",current_room.kind," ",current_room.variant)
				var doors = current_room.kind #get_doors_by_room(roomsGrid[y][x])
				for j in range(ROOM_SIZE):
					map.set_cell(x*ROOM_SIZE+j,y*ROOM_SIZE,0)
					map.set_cell(x*ROOM_SIZE+j,(y+1)*ROOM_SIZE-1,0)
				for i in range(ROOM_SIZE):
					map.set_cell(x*ROOM_SIZE,y*ROOM_SIZE+i,0)
					map.set_cell((x+1)*ROOM_SIZE-1,y*ROOM_SIZE+i,0)
				for j in range(1,ROOM_SIZE-1):
					for i in range(1,ROOM_SIZE-1):
						map.set_cell(x*ROOM_SIZE+j,y*ROOM_SIZE+i,1)
				var room_center = ROOM_SIZE/2
				
				if doors[0]: # porta UP
					print("UP WALL")
					for k in range(-2,3):
						map.set_cell(x*ROOM_SIZE+k + room_center,y*ROOM_SIZE,1)
				if doors[1]: # porta DOWN TODO
					print("DOWN WALL")
					for k in range(-2,3):
						map.set_cell(x*ROOM_SIZE+k + room_center,(y+1)*ROOM_SIZE-1,1)
				if doors[2]: # porta LEFT TODO
					print("LEFT WALL")
					for k in range(-2,3):
						map.set_cell(x*ROOM_SIZE,y*ROOM_SIZE+k + room_center,1)
				if doors[3]: # porta RIGHT TODO
					print("RIGHT WALL")
					for k in range(-2,3):
						map.set_cell((x+1)*ROOM_SIZE-1,y*ROOM_SIZE+k + room_center,1)

	var start_pos = Vector2(16*rooms[0].x*ROOM_SIZE, 16*rooms[0].y*ROOM_SIZE) + Vector2(16*ROOM_SIZE/2,16*ROOM_SIZE/2)
	var orc_room = 1+ randi() % (len(rooms)-1)
	var orc_pos = 	Vector2(16*rooms[orc_room].x*ROOM_SIZE, 16*rooms[orc_room].y*ROOM_SIZE) + Vector2(16*ROOM_SIZE/2,16*ROOM_SIZE/2)		
	$heroBody.global_position = start_pos
	$Orc.global_position = orc_pos
	
	Events.emit_signal("map_generation_end",start_pos)
	
	
	## connect events
	Events.connect("hit",self,"on_hit")
	
func on_hit(entity):
	print("hit: ",entity)	
	var damage_ui = EntityDamageUI.instance()
	damage_ui.set_global_position(entity.global_position)
	add_child(damage_ui)
	damage_ui.start()
	#for cell in $map.get_used_cells():
	#	print($map.get_cellv(cell))
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _unhandled_input(event: InputEvent) -> void:
	
	if not event is InputEventMouseButton:
		return
	#print(event.button_index, ' ', event.is_pressed())
	if event.button_index != BUTTON_LEFT or not event.is_pressed():
		return
	#print(event)
	var new_path = $Navigation2D.get_simple_path($heroBody.global_position,$Orc.global_position)
	$Line2D.points = new_path
	
func _process(delta):
	pass
	
