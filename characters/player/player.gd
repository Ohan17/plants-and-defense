class_name Player
extends CharacterBody2D

@export var hitsound : String
const SPEED: float = 0.7
@onready var health_max : float = 3.0
var health : float = 3.0
@onready var camera_2d = $Camera2D
var last_dir : Vector2

signal health_updated


func _input(_event):
	
	if Input.is_action_just_pressed("left"):
		last_dir = Vector2(-1,0)
	if Input.is_action_just_pressed("right"):
		last_dir = Vector2(1,0)
	if Input.is_action_just_pressed("forward"):
		last_dir = Vector2(0,-1)
	if Input.is_action_just_pressed("backward"):
		last_dir = Vector2(0,1)

func _physics_process(_delta: float):
	
	var direction := Input.get_vector("left", "right", "forward", "backward")

	if not direction:
		last_dir = Vector2.ZERO
	
	velocity = last_dir*SPEED/_delta#round(last_dir*SPEED)

	move_and_slide()
#	$Sprite2D.global_position = round(global_position)
#	camera_2d.global_position = $Sprite2D.global_position
	
func _process(_delta):
	$Sprite2D.global_position = round(global_position)
	camera_2d.global_position = round(global_position)
	
	
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
	$WeaponHolder._pickup_weapon(w_res)
