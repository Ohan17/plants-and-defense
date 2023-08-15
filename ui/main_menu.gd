extends TextureRect

@onready var anim_player = $AnimationPlayer

func _ready():
	AudioManager.play_music("Title")

func _on_start_button_button_down() -> void:
	anim_player.play("Intro_1")
	
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://level.tscn")


func _on_exit_button_button_down() -> void:
	get_tree().quit()


func _on_skip_button_button_up():
	get_tree().change_scene_to_file("res://level.tscn")
