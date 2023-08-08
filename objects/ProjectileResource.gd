extends Resource
class_name ProjectileResource

@export var speed : float = 5
@export var lifetime : float = 10
@export var damage : float = 1
#var homing : bool = false
@export var homing_factor : float = 1.0
@export var sprite : Texture2D 
@export var col_shape : Shape2D

enum ON_HIT {Explode,SlowArea}
@export var on_hit : bool = false
@export var on_hit_effect_type : ON_HIT

func on_hit_effect(pos : Vector2):
	match on_hit_effect_type:
		ON_HIT.Explode:
			var new_exp = load("res://objects/explosion.tscn").instantiate()
			Global.proj_cont.add_child(new_exp)
			new_exp.global_position = pos
		ON_HIT.SlowArea:
			var new_exp = load("res://objects/slow_area.tscn").instantiate()
			Global.proj_cont.add_child(new_exp)
			new_exp.global_position = pos
