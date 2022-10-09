extends Position2D

export var nodeType: String = "FREE"
var pos = Vector2.ZERO

func _ready():
	pos.x = (position.x-393)/110
	pos.y = (position.y-138)/110
