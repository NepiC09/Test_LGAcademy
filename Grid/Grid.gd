extends Node2D

onready var Chip = preload("res://Chips/Chip.tscn")

var chips: Array = [1,1,1,1,1, 2,2,2,2,2, 3,3,3,3,3, 0,0,0,0] #фишки для рандома
var targets: Array = [1,2,3] #какие стодлбцы нужно собрать (для рандома)
var arrayPivots = ArrayPivots

func _ready():
	arrayPivots.pivots.append_array(get_children())
	set_random()

func set_random():
	randomize()
	chips.shuffle()
	targets.shuffle()
	arrayPivots.targets = targets
	var i: int = 0
	for pivot in arrayPivots.pivots:
		if pivot.nodeType != "BLOCK" and i != chips.size():
			if chips[i] != 0:
				var chip = Chip.instance()
				chip.type = chips[i]
				chip.pos = pivot.pos 
				add_child(chip)
				chip.position = pivot.position
				chip.check_mission(chip.pos.x, 1)
				pivot.nodeType = "CHIP_" + chips[i] as String
			i += 1
	
	for j in 3:
		var chip = Chip.instance()
		chip.type = targets[j]
		var pivot = get_node(j as String)
		chip.blocked = true
		add_child(chip)
		chip.position = pivot.position 
		pivot.nodeType = "CHIP_" + targets[j] as String
	
