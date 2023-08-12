extends TextureRect


func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_file("res://level.tscn")


func _on_exit_button_button_down() -> void:
	get_tree().quit()
