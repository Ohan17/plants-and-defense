class_name EntitySprites
extends Node2D
## Handles changing day/night sprites
## usage: add sprites as child of this node and assign `day_sprite` and/or
## `night_sprite` accordingly


@export var day_sprite: Sprite2D
#	set(value):
#		day_sprite = value
#		if Global.is_day:
			#_show_sprite(value)
@export var night_sprite: Sprite2D
#	set(value):
#		night_sprite = value
#		if !Global.is_day:
			#_show_sprite(value)


func _ready() -> void:
#	Global.day_started.connect(func(): _show_sprite(day_sprite))
#	Global.night_started.connect(func(): _show_sprite(night_sprite))
	Global.day_started.connect(_transition_tilemap.bind(false))
	Global.night_started.connect(_transition_tilemap.bind(true))
	day_sprite.get_material().set("shader_parameter/blend_value",1.0)
	night_sprite.get_material().set("shader_parameter/blend_value",0.0)
	#_show_sprite(day_sprite)

func _transition_tilemap(day_to_night : bool):
	var tw = get_tree().create_tween().set_parallel()
	tw.tween_property(day_sprite.get_material(),"shader_parameter/blend_value",1.-float(day_to_night),Global.transition_time)
	tw.tween_property(night_sprite.get_material(),"shader_parameter/blend_value",float(day_to_night),Global.transition_time)
	

func _show_sprite(sprite: Sprite2D) -> void:
	for child in get_children():
		child.hide()
	if sprite:
		sprite.show()
