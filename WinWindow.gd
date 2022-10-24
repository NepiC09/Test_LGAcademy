extends Control

onready var tween = $Tween #плавное появление
onready var resultLabel = $ScoreTable/ResultLabel #таблица результатов

#плавное появление
func fade_in():
	visible = true
	modulate.a = 0
	tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 
							   0.5, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.start()

#установка результата
func set_results(var scores: Array):
	scores.sort()
	for i in scores:
		resultLabel.text += i as String + "\n";
