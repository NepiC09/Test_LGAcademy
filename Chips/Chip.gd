extends Node2D

onready var position2d = $Position2D
onready var sprite: Sprite = $Position2D/Sprite
onready var chip1_text = preload("res://Chips/Chip1.tres")
onready var chip2_text = preload("res://Chips/Chip2.tres")
onready var chip3_text = preload("res://Chips/Chip3.tres")
onready var timer = $Timer
onready var animationPlayer = $AnimationPlayer
onready var tween = $Tween

enum Types{
	CHIP_1,
	CHIP_2,
	CHIP_3
}
var type = Types.CHIP_1

var arrayPivots = ArrayPivots

var pos = Vector2.ZERO
var selected = false
var blocked = false

func set_texture(var num):
	match num:
		1:
			sprite.texture = chip1_text
		2:
			sprite.texture = chip2_text
		3:
			sprite.texture = chip3_text

func _ready():
	if type == 1:
		name = "CHIP_" + type as String + "_" + arrayPivots.index[0] as String
		arrayPivots.index[0] += 1
	elif type == 2:
		name = "CHIP_" + type as String + "_" + arrayPivots.index[1] as String
		arrayPivots.index[1] += 1
	elif type == 3:
		name = "CHIP_" + type as String + "_" + arrayPivots.index[2] as String
		arrayPivots.index[2] += 1
	set_texture(type)
	set_process(false)

# warning-ignore:unused_argument
func _process(delta):
	var input_direction = get_input_direction()
	if !input_direction:
		return
	var target = input_direction + pos
	target = clamp_vector(target, Vector2(0,0), Vector2(4,4))
	var pivot = arrayPivots.pivots[target.x + target.y*5]
	if pivot.nodeType == "FREE":
		move(pivot, input_direction)
	else:
		bloom()


func get_input_direction():
	return Vector2(
		int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left")),
		int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	)

func move(var target, var direction):
	set_process(false)
	
	check_mission(pos.x, -1)
	
	animationPlayer.play("Walk")
	tween.interpolate_property(position2d, "position", -direction*108, Vector2(), 
							   animationPlayer.current_animation_length, tween.TRANS_LINEAR, tween.EASE_IN)
	
	position = target.position
	arrayPivots.pivots[pos.x + pos.y*5].nodeType = "FREE"
	pos = target.pos
	target.nodeType = type as String
	
	check_mission(pos.x, 1)
	
	#yield(animationPlayer, "animation_finished")
	set_process(true)

func check_mission(var index, var value):
	if index == 0 and type == arrayPivots.targets[0]:
		arrayPivots.progress[0] += value
	if index == 2 and type == arrayPivots.targets[1]:
		arrayPivots.progress[1] += value
	if index == 4 and type == arrayPivots.targets[2]:
		arrayPivots.progress[2] += value

func bloom():
	set_process(false)
	animationPlayer.play("Bloom")
	#yield(animationPlayer,"animation_finished")
	set_process(true)


#выделение объекта через ЛКМ
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("l_mouse") and timer.is_stopped() and !blocked:
		selected = true
		modulate.r += 0.5
		modulate.g += 0.5
		modulate.b += 0.5
		set_process(true)
		timer.start()

#снятие выделения через ЛКМ
# warning-ignore:unused_argument
func _unhandled_input(event):
	if Input.is_action_just_released("l_mouse") and selected == true and timer.is_stopped():
		selected = false
		modulate.r -= 0.5
		modulate.g -= 0.5
		modulate.b -= 0.5
		set_process(false)
		timer.start()

func clamp_vector(var vector, var start, var end):
	vector.x = clamp(vector.x, start.x, end.x)
	vector.y = clamp(vector.y, start.y, end.y)
	return vector
