extends Area2D

@export var slow_dur : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles2D.set_emitting(true)
	do_damage()

func do_damage():
	for i in get_overlapping_bodies():
		if i is Enemy:
			i._to_slow(slow_dur)
	await get_tree().create_timer(1).timeout
	queue_free()
