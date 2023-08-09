class_name Plant
extends Node2D
## Defines the basic behavior for all plants, should not be attached to the parent of a scene


@export var days_to_grow: int = 1

var fully_grown : bool = false
@export var plant_day_grown : Texture2D
@export var plant_night_grown : Texture2D

func _ready() -> void:
	Global.night_started.connect(_on_night_started)


func _on_night_started() -> void:
	days_to_grow -= 1
	if days_to_grow == 0:
		Global.night_started.disconnect(_on_night_started)
		#$EntitySprites.day_sprite = $EntitySprites/PlantDay
		#$EntitySprites.night_sprite = $EntitySprites/PlantNight
		$EntitySprites/PlantDay.texture = plant_day_grown
		$EntitySprites/PlantNight.texture = plant_night_grown
		fully_grown = true

func _exit_tree() -> void:
	Map.set_tile(global_position, null)
