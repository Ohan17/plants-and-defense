class_name EquipmentPlant
extends Plant

@onready var interact_label = $InteractLabel
@export var weapon_r : WeaponResource

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_label.is_visible_in_tree():
		get_tree().get_nodes_in_group("Player")[0]._pickup_weapon(weapon_r)
		queue_free()
		
func _on_interact_area_body_entered(_body) -> void:
	if fully_grown:
		interact_label.show()


func _on_interact_area_body_exited(_body) -> void:
	interact_label.hide()
