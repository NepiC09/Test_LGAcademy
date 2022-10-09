extends Node2D

onready var sprite: Sprite = $Position2D/Sprite
onready var chip1_text = preload("res://Chips/Chip1.tres")
onready var chip2_text = preload("res://Chips/Chip2.tres")
onready var chip3_text = preload("res://Chips/Chip3.tres")
onready var timer = $Timer

enum Types{
	CHIP_1,
	CHIP_2,
	CHIP_3
}
var type = Types.CHIP_1

var pos = Vector2.ZERO
var target = Vector2.ZERO
var selected = false

func set_texture(var num):
	match num:
		1:
			sprite.texture = chip1_text
		2:
			sprite.texture = chip2_text
		3:
			sprite.texture = chip3_text

func _ready():
	set_texture(type)

func move():
	pass

func bloom():
	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("l_mouse") and timer.is_stopped():
		selected = true
		modulate.r += 0.5
		modulate.g += 0.5
		modulate.b += 0.5
		timer.start()

func _unhandled_input(event):
	if Input.is_action_just_released("l_mouse") and selected == true and timer.is_stopped():
		selected = false
		modulate.r -= 0.5
		modulate.g -= 0.5
		modulate.b -= 0.5
		timer.start()
