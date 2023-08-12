extends Area2D

@export var damage : float = 10
var is_exploding : bool = false


func _ready():
	$GPUParticles2D.set_emitting(true)
	#call_deferred("do_damage")


func _physics_process(_delta):
	if is_exploding:
		return
	do_damage()
	
func do_damage():
	is_exploding = true
	for i in get_overlapping_bodies():
		if i is Enemy:
			i.take_damage(damage)
	await get_tree().create_timer(0.7).timeout
	queue_free()
