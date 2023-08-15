extends ColorRect


@onready var animation_player = $AnimationPlayer

func open_screen():
	show()
	get_tree().paused = true
	animation_player.play("fade")
	$MarginContainer/VBoxContainer2/DeathText.text = "You survived %s days.  Taxation is inevitable."%Global.day



func _on_retry_button_button_up():
	get_tree().paused = false
	Global.restart_game()

func _on_exit_button_button_up():
	get_tree().quit()
