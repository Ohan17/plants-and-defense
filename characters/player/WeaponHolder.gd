extends Marker2D

@export var distance_to_player : float = 6
@onready var equipped_weapon : WeaponResource = preload("res://characters/player/Weapons/StandardWeapon.tres")
@onready var weapon_sprite = $WeaponSprite

@onready var proj_scene = preload("res://objects/projectileTemplate.tscn")
@onready var proj_container = get_tree().get_nodes_in_group("ProjectileContainer")[0]
#@onready var proj_type : ProjectileResource = preload("res://objects/simpleProjectile.tres")

@onready var StandardWeapon = preload("res://characters/player/Weapons/StandardWeapon.tres")
var durability : int = 1000
var fire_ready : bool = true

signal durability_updated

func _ready():
	reset_to_default_weapon()
	
	
func _process(_delta):
	var player_pos = get_parent().global_position
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - player_pos
	if direction.length() > 3:
		direction = direction.normalized()
		show_behind_parent = direction.y < 0
		position = distance_to_player*direction
		
		
	if Input.is_action_pressed("lmb") and not Global.is_day and fire_ready:
		fire_ready = false
		var proj = proj_scene.instantiate()
		proj_container.add_child(proj)
		proj.global_position = global_position
		proj._fire(direction.normalized(), null, equipped_weapon.projectile)
		SfxPlayer.play(equipped_weapon.fire_sound,global_position)
		durability -= 1
		emit_signal("durability_updated",abs(float(durability))/float(equipped_weapon.durability))
		if durability == 0:
			reset_to_default_weapon()
			fire_ready = true
			return
		
		await get_tree().create_timer(equipped_weapon.firerate).timeout
		fire_ready = true

func _pickup_weapon(w_res : WeaponResource):
	equipped_weapon = w_res
	durability = w_res.durability
	weapon_sprite.texture = w_res.weapon_sprite
	#SfxPlayer.play("weaponPickedUp")
	
func reset_to_default_weapon():
	equipped_weapon = StandardWeapon
	durability = equipped_weapon.durability
	weapon_sprite.texture = equipped_weapon.weapon_sprite
