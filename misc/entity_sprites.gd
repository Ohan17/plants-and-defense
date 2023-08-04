class_name EntitySprites
extends Node2D
## Handles changing day/night sprites
## usage: add sprites as child of this node and assign `day_sprite` and/or
## `night_sprite` accordingly


@export var day_sprite: Sprite2D:
	set(value):
		day_sprite = value
		if Global.is_day:
			_show_sprite(value)
@export var night_sprite: Sprite2D:
	set(value):
		night_sprite = value
		if !Global.is_day:
			_show_sprite(value)


func _ready() -> void:
	Global.day_started.connect(func(): _show_sprite(day_sprite))
	Global.night_started.connect(func(): _show_sprite(night_sprite))
	
	_show_sprite(day_sprite)


func _show_sprite(sprite: Sprite2D) -> void:
	for child in get_children():
		child.hide()
	if sprite:
		sprite.show()
