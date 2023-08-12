extends ColorRect


func open_screen():
	get_tree().paused = true
	$MarginContainer/VBoxContainer2/DeathText.text = "You survived %s days.  Taxation is inevitable."%Global.day
	show()


func _on_retry_button_button_up():
	Global.restart_game()
	get_tree().reload_current_scene()


func _on_exit_button_button_up():
	get_tree().quit()
