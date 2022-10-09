extends Node2D

onready var childs: Array = get_children()
onready var Chip = preload("res://Chips/Chip.tscn")

var chips: Array = [1,1,1,1,1, 2,2,2,2,2, 3,3,3,3,3, 0,0,0,0]

func _ready():
	set_random()

func set_random():
	randomize()
	chips.shuffle()
	var i: int = 0
	for pivot in childs:
		if pivot.nodeType != "BLOCK" and i != chips.size():
			if chips[i] != 0:
				var chip = Chip.instance()
				chip.type = chips[i]
				pivot.add_child(chip)
			i += 1
