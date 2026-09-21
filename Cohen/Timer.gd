extends CanvasLayer

var start_time: int

@onready var timer_label = $TimerLabel

func _ready():
	start_time = Time.get_ticks_msec()
	timer_label.text = "00:00.000"

func _process(_delta):
	var elapsed = Time.get_ticks_msec() - start_time

	var minutes = elapsed / 60000
	var seconds = (elapsed / 1000) % 60
	var milliseconds = elapsed % 1000

	timer_label.text = "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
