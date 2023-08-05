extends Node2D


@onready var y_sort: Node2D = $YSort
@onready var trader: Node2D = $YSort/Trader
@onready var night_timer: Timer = $NightTimer


func _ready() -> void:
	Global.night_started.connect(func(): 
		y_sort.remove_child(trader)
		night_timer.start()
	)
	Map.set_tile(trader.global_position, trader)
	Global.start_day()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb") \
	and Global.is_day \
	and Map.is_tile_empty(get_global_mouse_position()):
		var plant: Plant = preload("res://plants/offensive_plants/fire_blossom.tscn").instantiate()
		y_sort.add_child(plant)
		plant.global_position = TilePointer.tile_position
		Map.set_tile(plant.global_position, plant)
	
### maybe select what to plant to plant with right mouse button?

func _on_night_timer_timeout() -> void:
	y_sort.add_child(trader)
	Global.start_day()
