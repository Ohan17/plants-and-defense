extends TileMap


var tiles: Dictionary ## {Vector2i: Object}


func global_to_map(global_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(global_pos))


func map_to_global(map_position: Vector2i) -> Vector2:
	return to_global(map_to_local(map_position))


func get_tile_center(global_pos: Vector2) -> Vector2:
	return map_to_global(global_to_map(global_pos))


func is_tile_empty(global_pos: Vector2) -> bool:
	var coords: Vector2i = global_to_map(global_pos)
	return false if tiles.has(coords) and tiles[coords] != null else true


func set_tile(global_pos: Vector2, node: Node2D) -> void:
	if is_tile_empty(global_pos):
		tiles[global_to_map(global_pos)] = node
