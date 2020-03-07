extends Navigation2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ASTAR = ",get_simple_path(Vector2(0,0),Vector2(1000,1000)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
