extends Control

onready var timer = $Timer
onready var textLabel = $TextLabel

var time_sec = 0
var time_min = 0
var time_sec_string
var time_min_string

func _on_Timer_timeout():
	time_sec += 1
	if time_sec == 60:
		time_sec = 0
		time_min += 1
	if time_sec < 10:
		time_sec_string = "0" + time_sec as String
	else:
		time_sec_string = time_sec as String
	
	if time_min < 10:
		time_min_string = "0" + time_min as String
	else:
		time_min_string = time_min as String
	textLabel.text = "Time: " + time_min_string + ":" + time_sec_string
