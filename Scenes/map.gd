extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var astar = AStar.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	Events.connect("map_generation_end",self,"on_map_generation_end")

func on_map_generation_end(pos):
	print("map generation end -> ",pos)
	var game = Events.game
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
