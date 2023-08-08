extends Area2D
class_name Projectile

var proj_type : ProjectileResource
var direction := Vector2.RIGHT
var target : Enemy = null
@onready var collision_shape_2d = $CollisionShape2D


@onready var sprite_2d = $Sprite2D
var lifetime : float = 1000


func _fire(dir : Vector2, targ : Enemy, type : ProjectileResource):
	proj_type = type
	direction = dir.normalized()
	target = targ
	sprite_2d.texture = proj_type.sprite
	lifetime = proj_type.lifetime
	collision_shape_2d.shape = proj_type.col_shape
	
	
func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		
	if target:
		var p_to_t = (target.global_position - global_position).normalized()
		direction = (direction + p_to_t*proj_type.homing_factor).normalized()
	global_position += direction*proj_type.speed*delta
		


func _on_body_entered(body):
	if body is Enemy:
		if proj_type.on_hit:
			proj_type.on_hit_effect(global_position)
		body.take_damage(proj_type.damage)
		queue_free()
