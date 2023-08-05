class_name Enemy
extends CharacterBody2D

var enemy_res : EnemyResource
## Defines the basic behavior for all enemies, should not be attached to the parent of a scene
var health : float
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite = $Sprite2D
var has_attacked : bool = false
@onready var attack_timer = $AttackTimer

func initialize(en_res : EnemyResource):
	enemy_res = en_res
	health = enemy_res.max_health
	$Sprite2D.texture = enemy_res.sprite_night
	
	
func _physics_process(_delta):
	if has_attacked:
		return
	var dir = (player.global_position - global_position).normalized()
	velocity = enemy_res.speed*dir
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
	#maybe particle effect or death anim
	queue_free()


func _on_attack_timer_timeout():
	has_attacked = false
