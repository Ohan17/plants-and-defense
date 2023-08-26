class_name OffensivePlant
extends Plant


var enemies: Array[Enemy] = []
var closest_enemy: Enemy

@export var firerate : float = 0.6
@export var fire_range : int = 35
@export var proj_type : ProjectileResource
@onready var proj = preload("res://objects/Projectiles/projectileTemplate.tscn")
#@onready var proj_type = preload("res://objects/FireProjectile.tres")

func _ready() -> void:
	Global.night_started.connect(_on_night_started)
	$DetectionArea/CollisionShape2D.shape.radius = fire_range
	$FireTimer.start(firerate)
	$EntitySprites/PlantDay.texture = plant_day[0]
	$EntitySprites/PlantNight.texture = plant_night[0]
	
func calculate_closest_enemy() -> void:
	var current_closest_enemy: Enemy
	var closest_distance: float = Utils.MAX_FLOAT
	for enemy in enemies:
		#if not enemy.owner is Node2D:
		#	continue
		var distance: float = enemy.global_position.distance_to(global_position)
		if distance < closest_distance:
			closest_distance = distance
			current_closest_enemy = enemy
	closest_enemy = current_closest_enemy


func add_enemy(enemy: Enemy) -> void:
	if enemy not in enemies:
		enemies.append(enemy)
	if closest_enemy == null:
		calculate_closest_enemy()


func remove_enemy(enemy: Enemy) -> void:
	enemies.erase(enemy)
	if closest_enemy == enemy:
		calculate_closest_enemy()


func _on_detection_area_area_entered(area: Area2D) -> void:
	var enemy: Enemy = Utils.get_first_child_of_type(area.owner, Enemy)
	if enemy != null:
		add_enemy(enemy)


func _on_detection_area_area_exited(area: Area2D) -> void:
	var enemy: Enemy = Utils.get_first_child_of_type(area.owner, Enemy)
	if enemy == null:
		return
	remove_enemy(enemy)


func _on_detection_area_body_entered(body) -> void:
#	var enemy: Enemy = Utils.get_first_child_of_type(body, Enemy)
#	if enemy != null:
#		add_enemy(enemy)
	if body is Enemy:
		add_enemy(body)


func _on_detection_area_body_exited(body) -> void:
#	var enemy: Enemy = Utils.get_first_child_of_type(body, Enemy)
#	if enemy == null:
#		return
	if body is Enemy:
		remove_enemy(body)


func _on_fire_timer_timeout():
	if fully_grown and closest_enemy != null:
		var new_pr = proj.instantiate()
		Global.proj_cont.add_child(new_pr)
		new_pr.global_position = global_position
		var dir : Vector2 = (closest_enemy.global_position - global_position).normalized()
		new_pr._fire(dir,closest_enemy,proj_type)
		SfxPlayer.play(plant_sound)
