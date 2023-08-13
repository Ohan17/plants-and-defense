extends GPUParticles2D

@export var life_time : float = 1.1
# Called when the node enters the scene tree for the first time.
func _ready():
	set_emitting(true)
	await get_tree().create_timer(life_time).timeout
	queue_free()

