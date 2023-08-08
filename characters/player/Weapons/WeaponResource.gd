extends Resource
class_name WeaponResource

#enum AttackPattern {Straight, Fan}

@export var weapon_sprite : Texture2D
#@export var damage : int = 1
@export var firerate : float = 1
@export var durability : int = 10
@export var fire_sound : String = "res://assets/audio/random.wav"
@export var projectile : ProjectileResource
#@export var projectiles_per_use : int = 3
#@export var pattern : AttackPattern


#func get_weapon_pattern(dir : Vector2) -> Array[Vector2]:
#	match pattern:
#		AttackPattern.Straight:
#			return [dir]
#		AttackPattern.Fan:
#			var point_list : = []
#			for i in range(projectiles_per_use):
#				point_list.append(dir.rotated(-PI/180.0*15.0))
#			return point_list


	
	
