class_name DefensivePlant
extends Plant

@export var firerate : float = 2.5
@onready var particles = $GPUParticles2D
@onready var area_2d = $Area2D
@export var effect_dur : float = 1.1
@onready var fire_timer = $FireTimer

enum Effects {SLOW, POISON}
@export var plant_effect : Effects = Effects.SLOW


func _ready():
	Global.night_started.connect(_on_night_started)
	fire_timer.start(firerate)
	$EntitySprites/PlantDay.texture = plant_day[0]
	$EntitySprites/PlantNight.texture = plant_night[0]

func _on_fire_timer_timeout():
	if not fully_grown or Global.is_day:
		return
	particles.set_emitting(true)
	await get_tree().create_timer(0.2).timeout
	for i in area_2d.get_overlapping_bodies():
		if i is Enemy:
			match plant_effect:
				Effects.SLOW:
					i._to_slow(effect_dur)
				Effects.POISON:
					i._to_poison(effect_dur)
	
