class_name Player
extends CharacterBody2D


signal health_updated

const SPEED: float = 30.0

static var instance: Player

@export var hitsound : String

var health : float = 3.0
var health_max : float = 3.0


func _init() -> void:
	instance = self


func _physics_process(_delta: float):
	var direction: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	velocity = direction * SPEED
	move_and_slide()


func take_damage(val : float):
	SfxPlayer.play(hitsound,global_position)
	$Sprite2D/AnimationPlayer.play("hit_effect")
	health -= val
	emit_signal("health_updated",health/health_max)
	if health <0:
		death()


func death():
	print("dead")
	pass


func _pickup_weapon(w_res : WeaponResource):
	%WeaponHolder._pickup_weapon(w_res)
