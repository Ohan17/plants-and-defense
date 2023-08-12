extends Node2D


@onready var y_sort: Node2D = $YSort
@onready var trader: Node2D = $YSort/Trader

var next_plant_path : String = ""

var cost : int
var discounted : int

func _ready() -> void:
	Global.start_day()
	Global.night_started.connect(func(): y_sort.remove_child(trader))
	Global.day_started.connect(func(): y_sort.call_deferred("add_child", trader))
	Map.set_tile(trader.global_position, trader)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb") \
	and Global.is_day \
	and Map.is_tile_empty(TilePointer.tile_position) \
	and next_plant_path != "" :
		#var plant: Plant = preload("res://plants/offensive_plants/fire_blossom.tscn").instantiate()
		var plant : Plant = load(next_plant_path).instantiate()
		y_sort.add_child(plant)
		plant.global_position = TilePointer.tile_position
		Map.set_tile(plant.global_position, plant)
		
		Global.remove_resource(max(0,cost - int(discounted)))
		discounted = 0
		if not Global.has_resource(cost):
			clear_plant_order()
	if event.is_action_pressed("rmb") \
	and Global.is_day \
	and Global.is_placing:
		clear_plant_order()
		
func clear_plant_order():
		next_plant_path = ""
		Global.is_placing = false
		

func plant_to_place(plant_path : String, _cost : int, _discounted : int) -> void:
	next_plant_path = plant_path
	cost = _cost
	discounted = _discounted
	
