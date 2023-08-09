class_name Plant
extends Node2D
## Defines the basic behavior for all plants, should not be attached to the parent of a scene


@export var days_to_grow: int = 1
var fully_grown : bool = false


func _ready() -> void:
	Global.night_started.connect(_on_night_started)


func _on_night_started() -> void:
	days_to_grow -= 1
	if days_to_grow == 0:
		Global.night_started.disconnect(_on_night_started)
		$EntitySprites.day_sprite = $EntitySprites/PlantDay
		$EntitySprites.night_sprite = $EntitySprites/PlantNight
		fully_grown = true

func _exit_tree() -> void:
	Map.set_tile(global_position, null)
