extends Node


signal day_started
signal night_started
signal enemy_cleared


var day: int = 0
var is_day: = true


func start_day() -> void:
	day += 1
	is_day = true
	day_started.emit()


func start_night() -> void:
	is_day = false
	night_started.emit()
