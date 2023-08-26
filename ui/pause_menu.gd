extends ColorRect


var is_paused : bool = false

@onready var sfx_slider = $MarginContainer/VBoxContainer/SfxSlider
@onready var music_slider = $MarginContainer/VBoxContainer/MusicSlider
@onready var check_button = $MarginContainer/VBoxContainer/HBoxContainer/CheckButton


func _ready():
	hide()
	AudioServer.set_bus_volume_db(0,linear_to_db(1.0))
	AudioServer.set_bus_volume_db(1,linear_to_db(0.8))
	AudioServer.set_bus_volume_db(2,linear_to_db(0.8))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		change_pause()

func _on_continue_button_button_down():
	change_pause()


func change_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	set_visible(is_paused)


func _on_exit_button_button_down():
	get_tree().quit()


func _on_check_button_button_up():
	if check_button.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	


func _on_sfx_slider_drag_ended(value_changed):
	AudioServer.set_bus_volume_db(2,linear_to_db(sfx_slider.value))


func _on_music_slider_drag_ended(value_changed):
	AudioServer.set_bus_volume_db(1,linear_to_db(music_slider.value))
