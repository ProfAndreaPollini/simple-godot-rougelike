extends Node



var x
var y
var kind = -1
var variant =  -1

enum OPEN {
	UP = 1,
	DOWN = 2,
	LEFT = 4,
	RIGHT = 8
}



func _init(x,y):
	self.x = x
	self.y = y
