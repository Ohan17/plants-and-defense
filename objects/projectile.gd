extends Area2D
class_name Projectile

var proj_type : ProjectileResource
var direction := Vector2.RIGHT
var target : Enemy = null
@onready var collision_shape_2d = $CollisionShape2D
var rotate_to_dir : bool
var enemies_hit : Array[Enemy]= []

@onready var sprite_2d = $Sprite2D
var lifetime : float = 1000


func _fire(dir : Vector2, targ : Enemy, type : ProjectileResource):
	proj_type = type
	direction = dir.normalized()
	target = targ
	sprite_2d.texture = proj_type.sprite
	lifetime = proj_type.lifetime
	collision_shape_2d.shape = proj_type.col_shape
	rotate_to_dir = proj_type.projectile_rotated_to_dir
	
	
func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		
	if target and is_instance_valid(target):
		var p_to_t = (target.global_position - global_position).normalized()
		direction = (direction + p_to_t*proj_type.homing_factor).normalized()
	global_position += direction*proj_type.speed*delta
		
	if rotate_to_dir:
		rotation = floor((atan2(direction.y,direction.x)-PI/4.0)/(PI*0.5) +PI/4.0)*PI*0.5

func _on_body_entered(body):
	if body is Enemy and not (body in enemies_hit):
		if proj_type.on_hit:
			proj_type.on_hit_effect(global_position)
		body.take_damage(proj_type.damage,direction)
		if proj_type.on_hit_free:
			queue_free()
