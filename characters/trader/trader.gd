extends Node2D


@onready var interact_label: Label = $InteractLabel


func _ready() -> void:
	interact_label.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_label.is_visible_in_tree():
		Global.start_night()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	interact_label.show()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	interact_label.hide()
