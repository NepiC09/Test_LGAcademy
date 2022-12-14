extends Node2D

var pivots: Array #массив точек

var index: Array = [0,0,0] #для удобного названия фишек (чтобы искать по названию, а не через дополнительные массивы)
var targets: Array = [] #массив целевых фишек
var progress: Array = [0,0,0] setget set_progress #массив заполненности вертикалей
var win: Array = [false,false,false] #массив полного заполнения вертикалей
var main = null #указатель на мейн сцену
var chip_selected = null #указатель на выбранную фишку (для того, чтобы выбрать ТОЛЬКО 1 фишку) 

#установка заполненности вертикали
func set_progress(var value):
	progress = value
	if main != null:
		if value[0] == 5 and !win[0]:
			main.set_index_win(targets[0], 1)
			win[0] = true
		elif win[0] and value[0] == 4:
			win[0] = false
			main.set_index_win(targets[0], -1)
			
		if value[1] == 5 and !win[1]:
			main.set_index_win(targets[1], 1)
			win[1] = true
		elif win[1] and value[1] == 4:
			win[1] = false
			main.set_index_win(targets[1], -1)
		
		if value[2] == 5 and !win[2]:
			win[2] = true
			main.set_index_win(targets[2], 1)
		elif win[2] and value[2] == 4:
			win[2] = false
			main.set_index_win(targets[2], -1)
	if win[0] and win[1] and win[2]:
		main.super_win()

#сброс всех глобальных данных
func set_default():
	pivots = []
	index = [0,0,0] #создано для того, чтобы назначить удобные названия фишкам
	targets = []
	progress = [0,0,0]
	win = [false,false,false]
	main = null
	chip_selected = null
