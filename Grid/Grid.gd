extends Node2D

onready var Chip = preload("res://Chips/Chip.tscn") #фишки

#массив для рандомизации порядка появления фишек 0 - свободные фишки
var chips: Array = [1,1,1,1,1, 2,2,2,2,2, 3,3,3,3,3, 0,0,0,0] 
#массив для рандомизации целевых фишек 
var targets: Array = [1,2,3]

var globals = Globals #доступ к глобальным значениям

func _ready():
	globals.pivots.append_array(get_children()) #загруэаем все точки в глобальное значение
	set_random() #рандомо располагаем фишки


#рандомо располагаем фишки\
func set_random():
	randomize() #для отсутствия повторения рандома 
	chips.shuffle() #смешение массива фишек
	targets.shuffle() #смешение массива целевых вертикалей 
	globals.targets = targets #кидаем таргеты в глобальные данные
	var i: int = 0 #для цикла
	for pivot in globals.pivots:
		#блоки устанавливаются заранее, поэтому мы пропускаем их, но можно модифицировать при необходимости
		if pivot.nodeType != "BLOCK" and i != chips.size(): 
			if chips[i] != 0: #если по порядку идёт свободная фишка - пропускаем
				var chip = Chip.instance() #создаём образ фишки
				chip.type = chips[i] #устанавливем тип 
				chip.pos = pivot.pos #задаём позицию в виде индексов
				add_child(chip) #создаём фишку на самой сцене 
				chip.position = pivot.position #перемещяем к точке
				chip.check_mission(chip.pos.x, 1) #проверяем подходит ли фишка вертикали, если подходит - увеличиваем
				pivot.nodeType = "CHIP_" + chips[i] as String #устанавливаем тип фишки у точки
			i += 1 #переходим к следующей фишке
		pivot.connect("moved", get_parent(), "_start_timer") #связываем сигнал с мейном для начала таймера
	
	#настройка целевых фишек
	for j in 3:
		var chip = Chip.instance() #создаём образ фишки
		chip.type = targets[j] #устанвливаем тип
		var pivot = get_node(j as String) #получаем доступ к точке целевой фишки
		add_child(chip) #создаём фишку 
		chip.position = pivot.position #перемещяем 
		chip.blocked = true #указываем, что данную фишку нельзя выбрать (нельзя перемещать)
		pivot.first_set = 1 #устанавливаем значение 1, чтобы не тригерить сигнал перемещения фишки
		pivot.nodeType = "CHIP_" + targets[j] as String #устаналиваем тип точки

