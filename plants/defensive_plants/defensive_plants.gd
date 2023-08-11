class_name DefensivePlant
extends Plant

@export var firerate : float = 2.5
@onready var particles = $GPUParticles2D
@onready var area_2d = $Area2D
@onready var slow_dur : float = 1.1
@onready var fire_timer = $FireTimer


func _ready():
	Global.night_started.connect(_on_night_started)
	fire_timer.start(firerate)
	$EntitySprites/PlantDay.texture = plant_day[0]
	$EntitySprites/PlantNight.texture = plant_night[0]

func _on_fire_timer_timeout():
	if not fully_grown:
		return
	particles.set_emitting(true)
	await get_tree().create_timer(0.2).timeout
	for i in area_2d.get_overlapping_bodies():
		if i is Enemy:
			i._to_slow(slow_dur)
	
