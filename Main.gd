extends Node2D

var arrayPivots = ArrayPivots

func _ready():
	arrayPivots.main = self

func set_index_win(var value: int, var win):
	for i in 5:
		var chip = get_node("Grid/CHIP_" + value as String + "_"+i as String)
		print("win = " + win as String)
		chip.modulate.r += 0.3*win
		chip.modulate.g += 0.3*win
		chip.modulate.b += 0.3*win

func super_win():
	for i in 3:
		var chip = get_node("Grid/CHIP_" + i as String + "_5")
		print("WIN")
