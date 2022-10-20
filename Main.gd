extends Node2D

onready var WinWindow = $WinWindow
onready var tween = $Tween
onready var fade = $Fade
onready var timeContainer = $TimeContainer

var arrayPivots = ArrayPivots
var scoreTablePath = "res://ScoreTable.json"
var scoreTable: Array

func _ready():
	arrayPivots.main = self
	fade.visible = true
	fade_out()
	load_table()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		super_win()

func set_index_win(var value: int, var win):
	for i in 5:
		var chip = get_node("Grid/CHIP_" + value as String + "_"+i as String)
		print("win = " + win as String)
		chip.modulate.r += 0.3*win
		chip.modulate.g += 0.3*win
		chip.modulate.b += 0.3*win

func super_win():
	for i in 3:
		var chip = get_node("Grid/CHIP_" + (i + 1) as String + "_5")
		chip.modulate.r += 0.3
		chip.modulate.g += 0.3
		chip.modulate.b += 0.3
	WinWindow.fade_in();
	scoreTable.append(timeContainer.time_min_string + ":" + timeContainer.time_sec_string)
	save_table()
	WinWindow.set_results(scoreTable)
	get_tree().paused = true

func _on_RestartButton_pressed():
	get_tree().paused = false
	fade_in()
	arrayPivots.set_default()
	get_tree().reload_current_scene()

func fade_out():
	tween.interpolate_property(fade, "modulate", Color(1,1,1,1), Color(1,1,1,0), 
							   0.5, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.start()

func fade_in():
	fade.visible = false
	tween.interpolate_property(fade, "modulate", Color(1,1,1,0), Color(1,1,1,1), 
							   0.5, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.start()
	fade.visible = true

func load_table():
	var f = File.new()
	f.open(scoreTablePath, File.READ)
	var json = JSON.parse(f.get_as_text())
	f.close()
	scoreTable = json.result

func save_table():
	var f = File.new()
	f.open(scoreTablePath, File.WRITE)
	f.store_line(to_json(scoreTable))
	f.close()
