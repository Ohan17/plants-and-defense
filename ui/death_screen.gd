extends ColorRect


@onready var animation_player = $AnimationPlayer

func open_screen():
	show()
	get_tree().paused = true
	animation_player.play("fade")



func _on_retry_button_button_up():
	get_tree().paused = false
	Global.restart_game()
	get_tree().reload_current_scene()


func _on_exit_button_button_up():
	get_tree().quit()
