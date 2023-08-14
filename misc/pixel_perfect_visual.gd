class_name PixelPerfectVisual
extends Node2D


@export var root_node: CharacterBody2D

@onready var pre_pos: Vector2 = global_position


func _ready() -> void:
	top_level = true
	if !root_node:
		root_node = owner


func _process(_delta: float) -> void:
	if abs(root_node.velocity.aspect()) == 1:
		var delta_pos: Vector2 = root_node.global_position.round() - pre_pos
		if abs(delta_pos.aspect()) == 1:
			global_position = root_node.global_position.round()
		elif delta_pos[delta_pos.max_axis_index()] > 1:
			global_position += delta_pos
	else:
		global_position = root_node.global_position.round()
	pre_pos = global_position
