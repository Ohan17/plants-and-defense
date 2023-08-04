class_name TilePointer
extends Sprite2D


static var tile: Vector2i
static var tile_position: Vector2

@export var tile_map: TileMap


func _process(_delta: float) -> void:
	tile = Map.global_to_map(get_global_mouse_position())
	tile_position = Map.map_to_global(tile)
	global_position = tile_position
