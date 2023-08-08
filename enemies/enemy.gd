class_name Enemy
extends CharacterBody2D

signal enemy_cleared

static var count: = 0:
	set(value):
		count = value
#		if count == 0:
#			Global.enemy_cleared.emit()

var enemy_res : EnemyResource
## Defines the basic behavior for all enemies, should not be attached to the parent of a scene
var health : float
var has_attacked : bool = false
var is_dying : bool = false

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite = $Sprite2D
@onready var attack_timer = $AttackTimer
var slowing_factor : float = 1.0


func initialize(en_res : EnemyResource):
	enemy_res = en_res
	health = enemy_res.max_health
	$Sprite2D.texture = enemy_res.sprite_night
	$CollisionShape2D.polygon = enemy_res.coll_points


func _enter_tree() -> void:
	count += 1


func _physics_process(_delta):
	if has_attacked:
		return
	var dir = (player.global_position - global_position).normalized()
	velocity = enemy_res.speed*dir*slowing_factor
	var col = move_and_collide(velocity*_delta)
	if col and (col.get_collider() is Player):
		has_attacked = true
		### do damage to player 
		### then dont move for a bit?
		col.get_collider().take_damage(enemy_res.damage)
		attack_timer.start(1)
	
	
func take_damage(val : float):
	health -= val
	if health < 0:
		death()


func death():
	if is_dying:
		return
	is_dying = true
	#maybe particle effect or death anim
	Global.spawn_resource(global_position)
	count -= 1
	emit_signal("enemy_cleared",count)
	queue_free()


func _on_attack_timer_timeout():
	has_attacked = false

func _to_slow(dur : float):
	slowing_factor = 0.5
	await get_tree().create_timer(dur).finished
	var tw = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self,"slowing_factor",1.0,1.0)
	
