extends Resource
class_name EnemyResource

enum AttackPatterns {WALK_INTO, DASH}

@export var max_health : float = 5
@export var speed : float = 20
@export var damage : float = 1.0

@export var sprite_night : Texture2D
@export var animation_sprites : int = 1
@export var coll_points : PackedVector2Array
@export var attack_pattern : AttackPatterns = AttackPatterns.WALK_INTO
