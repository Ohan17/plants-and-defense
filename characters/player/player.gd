class_name Player
extends CharacterBody2D


signal health_updated

const SPEED: float = 30.0

static var instance: Player
@onready var sprite = $PixelPerfectVisual/Sprite2D

@export var hitsound : String

var health : float = 5.0
var health_max : float = 5.0
var is_dead : bool = false

func _init() -> void:
	instance = self
	Global.day_started.connect(heal_fully)

func _physics_process(_delta: float):
	var direction: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	velocity = direction * SPEED
	move_and_slide()
	update_sprite(direction)

func update_sprite(dir : Vector2):
	var new_frame : int = 0
	if not dir:
		return
	new_frame = int(dir.y > 0) + int(dir.y < 0)*2
	if dir.x:
		new_frame = int(dir.x>0)*3
	#new_frame = int(dir.x>0)*3 
	sprite.frame = new_frame

func take_damage(val : float):
	if is_dead:
		return
	SfxPlayer.play(hitsound,global_position)
	$PixelPerfectVisual/Sprite2D/AnimationPlayer.play("hit_effect")
	$PixelPerfectVisual/Camera2D.apply_noise_shake()
	health -= val
	emit_signal("health_updated",health/health_max)
	if health <0:
		is_dead = true
		$DeathScreen/DeathScreen.open_screen()

func heal_fully():
	health = health_max
	emit_signal("health_updated",health/health_max)

func pickup_weapon(w_res : WeaponResource):
	%WeaponHolder.pickup_weapon(w_res)
