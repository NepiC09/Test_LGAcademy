extends Node2D

onready var WinWindow = $WinWindow #окно победы
onready var tween = $Tween #для плавного измнения alpha у fade
onready var fade = $Fade #затеменение для перехода
onready var timeContainer = $TimeContainer #секундомер

var globals = Globals #глобальные данные 
var scoreTablePath = "user://ScoreTable.json" #файл со всеми результатами
var scoreTable: Array = [] #массив таблицы результатов

func _ready():
	globals.main = self 
	fade.visible = true
	fade_out() #плавное открытие уровня
	load_table() #заполнения массива результатов

#чит-код на прохождение :З
#func _unhandled_input(event):
#	if Input.is_action_just_pressed("ui_accept"):
#		super_win()

#визуальное представления собранной вертикали
func set_index_win(var value: int, var win):
	for i in 5:
		var chip = get_node("Grid/CHIP_" + value as String + "_"+i as String)
		chip.modulate.r += 0.3*win
		chip.modulate.g += 0.3*win
		chip.modulate.b += 0.3*win

#при полной победе 
func super_win():
	#освещяет всё
	for i in 3:
		var chip = get_node("Grid/CHIP_" + (i + 1) as String + "_5")
		chip.modulate.r += 0.3
		chip.modulate.g += 0.3
		chip.modulate.b += 0.3
	WinWindow.fade_in(); #плавное открытие окна победы
	scoreTable.append(timeContainer.time_min_string + ":" + timeContainer.time_sec_string) #заполнение таблицы результатов
	save_table() #сохранение :)
	WinWindow.set_results(scoreTable) #обвноление текстового окна результатов
	get_tree().paused = true #остановка всей игры

#перезагрузка сцены
func _on_RestartButton_pressed(): 
	get_tree().paused = false
	fade_in()
	globals.set_default()
	get_tree().reload_current_scene()

#плавный выход из тьмы, мой загадочный друг
func fade_out():
	tween.interpolate_property(fade, "modulate", Color(1,1,1,1), Color(1,1,1,0), 
							   0.5, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.start()

#плавный вход во тьму. Не совершай ошибок, ты ещё можешь привенсти в мир красоту
func fade_in():
	fade.visible = false
	tween.interpolate_property(fade, "modulate", Color(1,1,1,0), Color(1,1,1,1), 
							   0.5, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.start()
	fade.visible = true

#считывание из json файла результаты
func load_table():
	var f = File.new()
	if !f.file_exists(scoreTablePath):
		f.open(scoreTablePath, File.WRITE)
		f.store_line(to_json(scoreTable))
		f.close()
	f.open(scoreTablePath, File.READ)
	var json = JSON.parse(f.get_as_text())
	f.close()
	scoreTable = json.result

#сохранение в json файлы
func save_table():
	var f = File.new()
	f.open(scoreTablePath, File.WRITE)
	f.store_line(to_json(scoreTable))
	f.close()

#начало таймера (срабатывает по сигналу после первого перемещения фишки)
func _start_timer():
	if timeContainer.timer.is_stopped():
		timeContainer.timer.start()
