extends Position2D

export var nodeType: String = "FREE" setget set_nodeType
var first_set = 1
signal moved
var pos = Vector2.ZERO

func _ready():
	pos.x = (position.x-393)/110
	pos.y = (position.y-138)/110

func set_nodeType(value):
	nodeType = value
	if first_set == 0:
		emit_signal("moved")
	first_set -=1
