class_name OffensivePlant
extends Plant


var enemies: Array[Enemy] = []
var closest_enemy: Enemy


func calculate_closest_enemy() -> void:
	var current_closest_enemy: Enemy
	var closest_distance: float = Utils.MAX_FLOAT
	for enemy in enemies:
		if not enemy.owner is Node2D:
			continue
		var distance: float = enemy.owner.position.distance_to(owner.position)
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


func _on_detection_area_body_entered(body: Node2D) -> void:
	var enemy: Enemy = Utils.get_first_child_of_type(body, Enemy)
	if enemy != null:
		add_enemy(enemy)


func _on_detection_area_body_exited(body: Node2D) -> void:
	var enemy: Enemy = Utils.get_first_child_of_type(body, Enemy)
	if enemy == null:
		return
	remove_enemy(enemy)
