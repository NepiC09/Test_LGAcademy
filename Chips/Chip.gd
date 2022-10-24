extends Node2D

onready var position2D = $Position2D #для плавного перемещения спрайта (спрайт привязан к этому пивоту)
onready var sprite: Sprite = $Position2D/Sprite #спрайт :З

onready var chip1_text = preload("res://Chips/img/Chip-01.png") #текстура 1-ого типа
onready var chip2_text = preload("res://Chips/img/Chip-02.png") #текстура 2-ого типа
onready var chip3_text = preload("res://Chips/img/Chip-03.png") #текстура 3-ого типа
onready var timer = $Timer #для задержки в инпуте
onready var animationPlayer = $AnimationPlayer #анимация перемещения и движения в блок
onready var tween = $Tween #плавное перемещение спрайта

#типы фишек
enum Types{
	CHIP_1,
	CHIP_2,
	CHIP_3
}
var type = Types.CHIP_1

var globals = Globals #доступ к глобальным данным

var pos = Vector2.ZERO #позиция в виде индексов
var mouse_pos = Vector2.ZERO #последняя позиция мыши
var mouse_moving = false #перемещение мыши
var blocked = false #возможность выбрать фишку (нельзя выбрать целевые фишки)
var selected = false #выбрана фишка или нет 
var dragging = false #можно ли перемещать фишку или нет через удерживание
var old_global_position #последняя позиция

#установка текстуры
func set_texture(var num):
	match num:
		1:
			sprite.texture = chip1_text
		2:
			sprite.texture = chip2_text
		3:
			sprite.texture = chip3_text

func _ready():
	#установка текстуры и имени фишки (для удобного выбора фишки без дополнительного массива)
	if type == 1:
		name = "CHIP_" + type as String + "_" + globals.index[0] as String
		globals.index[0] += 1
	elif type == 2:
		name = "CHIP_" + type as String + "_" + globals.index[1] as String
		globals.index[1] += 1
	elif type == 3:
		name = "CHIP_" + type as String + "_" + globals.index[2] as String
		globals.index[2] += 1
	set_texture(type) #установка текстуры
	set_process(false) #остановка процесса

# warning-ignore:unused_argument
func _process(delta):
	#перемещение мышью
	if dragging:
		global_position = get_global_mouse_position()
	
	var input_direction: Vector2 #направление полученное через инпут
	if mouse_pos != Vector2.ZERO: #если было перемещение мышью, то устанавливается направление по мыши
		input_direction = mouse_pos
		mouse_pos = Vector2.ZERO
	else: #иначе по клавиатуре
		input_direction = get_input_direction()
	if !input_direction: #если направления нет - остановка текущей обработки
		return
	
	var target = input_direction + pos #целевое перемещение 
	target = clamp_vector(target, Vector2(0,0), Vector2(4,4)) #ограничение в соотвествии с сеткой
	var pivot = globals.pivots[target.x + target.y*5] #доступ к точке, на которую перемещается 
	if pivot.nodeType == "FREE": #если целевая точка свободна - переместить
		move(pivot, input_direction)
	else:
		bloom()

#получение вектора из кнопок
func get_input_direction():
	return Vector2(
		int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left")),
		int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	)

#перемещение
func move(var target, var direction):
	set_process(false) #останавливаем процесс
	check_mission(pos.x, -1) #снижаем на 1 прогресс, если фишка была на целевой вертикали 
	
	animationPlayer.play("Walk") #анимация перемещения
	#плавное смещение спрайта
	tween.interpolate_property(position2D, "position", -direction*108, Vector2(), 
							   animationPlayer.current_animation_length, tween.TRANS_LINEAR, tween.EASE_IN)
	
	position = target.position #изменение фактической позиции
	globals.pivots[pos.x + pos.y*5].nodeType = "FREE" #предыдущая клетка становится свободной
	pos = target.pos #обновляем позицию
	target.nodeType = type as String #указываем у новой точки позицию
	
	check_mission(pos.x, 1) #увеличиваем на 1 прогресс, если фишка попала на нужную вертикаль
	old_global_position = global_position #обновляем старую позицию
	set_process(true)

#проверка - находится ли фишка на целевой вертикали
func check_mission(var index, var value):
	if index == 0 and type == globals.targets[0]:
		globals.progress[0] += value
	if index == 2 and type == globals.targets[1]:
		globals.progress[1] += value
	if index == 4 and type == globals.targets[2]:
		globals.progress[2] += value

#анимация перемещения "в стену"
func bloom():
	set_process(false)
	animationPlayer.play("Bloom")
	set_process(true)


#выделение объекта через ЛКМ
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Area2D_input_event(viewport, event, shape_idx):
	#выделение фишки мышью
	if Input.is_action_just_pressed("l_mouse") and timer.is_stopped() and selected == false and !blocked:
		if globals.chip_selected != null: #если есть выделенная фишка
			globals.chip_selected.select(false) #снимаем выделение
			globals.chip_selected = self #обновляем указатель
		else:
			globals.chip_selected = self #обновляем указатель
		select(true) #выделяем
		timer.start() #задержка следующего ввода
	#начало перемещения мышью
	if Input.is_action_just_pressed("l_mouse"): 
		old_global_position = global_position
		dragging = true

# warning-ignore:unused_argument
func _unhandled_input(event):
	#перемещение мышью
	if Input.is_action_just_released("l_mouse") and selected == true and timer.is_stopped():
		global_position = old_global_position
		dragging = false
		get_mouse_pos() #получение позиции мыши в индексах
		timer.start()


#ограничение вектора
func clamp_vector(var vector, var start, var end):
	vector.x = clamp(vector.x, start.x, end.x)
	vector.y = clamp(vector.y, start.y, end.y)
	return vector

#функция выделения
func select(value):
	var mod_changed
	if value == true:
		mod_changed = 1
	else:
		mod_changed = -1
	selected = value
	modulate.r += 0.5*mod_changed
	modulate.g += 0.5*mod_changed
	modulate.b += 0.5*mod_changed
	scale += Vector2(0.05,0.05)*mod_changed
	set_process(value)

#получение позиции мыши в индексах
func get_mouse_pos():
	mouse_pos = (get_global_mouse_position() - position2D.global_position)/108
	var radius = 200 #радиус перетаскивания (мож
	if mouse_pos.x > radius or mouse_pos.x < -radius or mouse_pos.y > radius or mouse_pos.y < -radius:
		mouse_pos = Vector2.ZERO
		select(false)
		globals.chip_selected = null
	
	var motion_lenght = 1 #можно поставить значение больше и перемещать сразу на несколько клетов
	mouse_pos.x = clamp(int(round(mouse_pos.x)),-motion_lenght, motion_lenght)
	mouse_pos.y = clamp(int(round(mouse_pos.y)),-motion_lenght, motion_lenght)
	
	#убираем диагональное смещение
	if mouse_pos.x != 0 and mouse_pos.y != 0:
		mouse_pos = Vector2.ZERO
