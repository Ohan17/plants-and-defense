class_name Enemy
extends CharacterBody2D

signal enemy_cleared

static var count: = 0:
	set(value):
		count = value
		
#		if count == 0:
#			Global.enemy_cleared.emit()

static var kill_count := 0

var enemy_res : EnemyResource
## Defines the basic behavior for all enemies, should not be attached to the parent of a scene
var health : float
var has_attacked : bool = false
var is_dying : bool = false
var anim_time : float = 0
const anim_update_time : float = 0.2
var elapsed_time : float = 0.0
var atk_pattern_time : float = 3.0

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite = $Sprite2D
@onready var attack_timer = $AttackTimer
var slowing_factor : float = 1.0
var stun_factor : float = 1.0
var poison_timer : float = 0.0
@export var poison_ticks_time : float = 1.0
var last_poison_tick : float = 0.0
@export var poison_damage : float = 2.0

@onready var slow_particles = $SlowParticles
@onready var hit_particle = preload("res://objects/enemy_hit_particle.tscn")
@onready var poison_particle = preload("res://objects/poison_particle.tscn")
@onready var death_particle = preload("res://enemies/death_particle.tscn")
enum AttackPatterns {WALK_INTO, DASH, ZICKZACK}

var skip_spawn_resource : bool = false

func initialize(en_res : EnemyResource) -> void:
	enemy_res = en_res
	health = enemy_res.max_health
	$Sprite2D.texture = enemy_res.sprite_night
	$CollisionShape2D.polygon = enemy_res.coll_points
	$Sprite2D.hframes = enemy_res.animation_sprites
	atk_pattern_time = en_res.attack_pattern_time


func _enter_tree() -> void:
	count += 1
	emit_signal("enemy_cleared",count)


func _physics_process(delta):
	stun_factor = clamp(stun_factor + 2*delta,0.0,1.0)
	if has_attacked:
		return
	elapsed_time += delta
	var dir = (player.global_position - global_position).normalized()
	if elapsed_time > atk_pattern_time:
		elapsed_time = 0
	match enemy_res.attack_pattern:
		AttackPatterns.WALK_INTO:
			velocity = enemy_res.speed*dir
		AttackPatterns.DASH:
			velocity = pow(elapsed_time/atk_pattern_time,2)*enemy_res.speed*dir
		AttackPatterns.ZICKZACK:
			var nrml_dir = Vector2(dir.y,dir.x)
			dir = (nrml_dir*sin(elapsed_time/PI*1.5) + dir).normalized()
			velocity = enemy_res.speed*dir
	
	velocity *= slowing_factor*stun_factor
	var col = move_and_collide(velocity*delta)
	if col and (col.get_collider() is Player):
		has_attacked = true
		col.get_collider().take_damage(enemy_res.damage)
		elapsed_time = 0
		attack_timer.start(1)
	update_poison(delta)
	
func _process(delta):
	anim_time += delta
	if anim_time > anim_update_time:
		anim_time = 0
		sprite.frame = (sprite.frame + 1)%enemy_res.animation_sprites
	
func take_damage(val : float, hit_dir : Vector2 = Vector2.ZERO) -> void:
	if hit_dir:
		var hit_p = hit_particle.instantiate()
		Global.proj_cont.add_child(hit_p)
		hit_p.global_position = global_position
		hit_p.process_material.direction = Vector3(hit_dir.x,hit_dir.y,0.0)
	health -= val
	$Sprite2D/AnimationPlayer.play("hit_effect")
	if health < 0:
		death()


func death() -> void:
	if is_dying:
		return
	is_dying = true
	count -= 1
	kill_count += 1
	

	if kill_count%2 == 0 and not skip_spawn_resource:
		if not enemy_res.gives_resource:
			skip_spawn_resource = true
		else:
			Global.spawn_resource(global_position)
	if skip_spawn_resource and enemy_res.gives_resource:
		Global.spawn_resource(global_position)
		skip_spawn_resource = false
			
	emit_signal("enemy_cleared",count)
	var death_p = death_particle.instantiate()
	Global.proj_cont.add_child(death_p)
	death_p.global_position = global_position
	queue_free()


func _on_attack_timer_timeout() -> void:
	has_attacked = false

func _to_slow(dur : float) -> void:
	slowing_factor = 0.5
	slow_particles.set_emitting(true)
	await get_tree().create_timer(dur).timeout
	var tw = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self,"slowing_factor",1.0,1.0)
	slow_particles.set_emitting(false)
	
func _to_poison(dur : float):
	stun_factor = 0.0
	poison_timer = dur
	last_poison_tick = dur
	var poi_p = poison_particle.instantiate()
	Global.proj_cont.add_child(poi_p)
	poi_p.global_position = global_position
	
func update_poison(delta : float):
	poison_timer -= delta
	if poison_timer > 0 and (last_poison_tick - poison_timer ) > poison_ticks_time:
		last_poison_tick = poison_timer
		take_damage(poison_damage)
		var poi_p = poison_particle.instantiate()
		Global.proj_cont.add_child(poi_p)
		poi_p.global_position = global_position
