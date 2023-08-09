class_name Player
extends CharacterBody2D

@export var hitsound : String
const SPEED: float = 30.0
@onready var health_max : float = 3.0
var health : float = 3.0

signal health_updated


func _physics_process(_delta: float):

	var direction := Input.get_vector("left", "right", "forward", "backward")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func take_damage(val : float):
	SfxPlayer.play(hitsound,global_position)
	health -= val
	emit_signal("health_updated",health/health_max)
	if health <0:
		death()
		
func death():
	print("dead")
	pass
	
func _pickup_weapon(w_res : WeaponResource):
	$WeaponHolder._pickup_weapon(w_res)
