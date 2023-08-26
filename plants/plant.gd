class_name Plant
extends Node2D
## Defines the basic behavior for all plants, should not be attached to the parent of a scene

@export var plant_sound : String
@export var days_to_grow: int = 1

var fully_grown : bool = false
@export var plant_day : Array[Texture2D]
@export var plant_night :  Array[Texture2D]
@onready var days_passed : int = 0

func _ready() -> void:
	Global.night_started.connect(_on_night_started)
	$EntitySprites/PlantDay.texture = plant_day[0]
	$EntitySprites/PlantNight.texture = plant_night[0]

func _on_night_started() -> void:
	days_to_grow -= 1
	days_passed += 1
	$EntitySprites/PlantDay.texture = plant_day[days_passed]
	$EntitySprites/PlantNight.texture = plant_night[days_passed]
	if days_to_grow == 0:
		Global.night_started.disconnect(_on_night_started)
		fully_grown = true

func _exit_tree() -> void:
	Map.set_tile(global_position, null)
