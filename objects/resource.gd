extends Area2D

@export var pickupSound : String

func _ready():
	$AnimationPlayer.play("shine")
	
func _on_body_entered(body):
	if body is Player:
		Global.add_resource()
		SfxPlayer.play(pickupSound,global_position)
		queue_free()
