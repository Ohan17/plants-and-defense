extends Marker2D

@export var distance_to_player : float = 6
@onready var equipped_weapon = null

@onready var proj_scene = preload("res://objects/projectileTemplate.tscn")
@onready var proj_container = get_tree().get_nodes_in_group("ProjectileContainer")[0]
#@onready var proj_type : ProjectileResource = preload("res://objects/simpleProjectile.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player_pos = get_parent().global_position
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - player_pos
	if direction.length() > 3:
		direction = direction.normalized()
		show_behind_parent = direction.y < 0
		position = distance_to_player*direction
		
	if Input.is_action_just_pressed("lmb") and not Global.is_day:
		match equipped_weapon:
			null:
				var proj = proj_scene.instantiate()
				proj_container.add_child(proj)
				proj.global_position = global_position
				proj._fire(direction.normalized(), null, load("res://objects/StandardProjectile.tres"))
		
