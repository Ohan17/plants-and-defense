extends Area2D

@export var damage : float = 10



func _ready():
	$GPUParticles2D.set_emitting(true)
	do_damage()

func do_damage():
	for i in get_overlapping_bodies():
		if i is Enemy:
			i.take_damage(damage)
	await get_tree().create_timer(0.7).timeout
	queue_free()
