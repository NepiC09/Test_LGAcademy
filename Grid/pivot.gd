extends Position2D

export var nodeType: String = "FREE" setget set_nodeType #тип фишки, на точке
var first_set = 1 #так как первое появление тоже считается "пермещением", сделал эту переменную
signal moved #фишка перемещена
var pos = Vector2.ZERO #позиция точки в индексах

func _ready():
	#393 и 138 - начальные позиции
	#110 - размер фишки
	pos.x = (position.x-393)/110 
	pos.y = (position.y-138)/110

#при изменении переменной nodeType вызывается эта функция
func set_nodeType(value):
	nodeType = value
	if first_set == 0: #первое фактическое перемещение будет вторым, поэтому тут такое условие
		emit_signal("moved") #отправляю сигнал о перемещении фишки
	first_set -=1 
