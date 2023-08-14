extends Node

@onready var res_scene = preload("res://objects/resource.tscn")
@onready var proj_cont #= get_tree().get_nodes_in_group("ProjectileContainer")[0]

signal day_started
signal night_started
signal enemy_cleared
signal resources_updated

var day: int = 0
var is_day: = true
var transition_time : float = 2.0

var is_placing : bool = false
@onready var resources : int = 3

var shop_unlocked : bool = false

func level_initialized(proj_container : Node2D):
	proj_cont = proj_container

func start_day() -> void:
	print("day started")
	day += 1
	is_day = true
	day_started.emit()


func start_night() -> void:
	is_day = false
	is_placing = false
	night_started.emit()


### Resource related functions
func add_resource(val : int = 1) -> void:
	resources += val
	emit_signal("resources_updated", resources)

func has_resource(req_res : int) -> bool:
	if resources >= req_res:
		return true
	else:
		return false
		
func remove_resource(rem_res : int) -> void:
	resources -= rem_res
	emit_signal("resources_updated", resources)
	
func spawn_resource(pos : Vector2):
	var new_res = res_scene.instantiate()
	proj_cont.call_deferred("add_child",new_res)
	#call_deferred("add_child", new_res)
	new_res.global_position = pos
	
func restart_game():
	Enemy.kill_count = 0
	day = 0
	resources = 3
