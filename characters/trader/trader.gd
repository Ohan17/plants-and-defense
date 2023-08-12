extends Node2D


@onready var interact_label: Label = $InteractLabel
@onready var anim_player = $AnimationPlayer


func _ready() -> void:
	interact_label.hide()
	anim_player.play("Appear")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_label.is_visible_in_tree():
		anim_player.play("Vanish")
		await anim_player.animation_finished
		Global.start_night()

func _process(_delta):
	if not anim_player.is_playing():
		anim_player.play("Trader_idle")

func _on_area_2d_body_entered(_body: Node2D) -> void:
	interact_label.show()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	interact_label.hide()
