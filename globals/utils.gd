extends Node


const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN
]
const ORDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i(-1, -1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(1, 1)
]
const COMPASS_DIRECTIONS: Array[Vector2i] = CARDINAL_DIRECTIONS + ORDINAL_DIRECTIONS


const MAX_FLOAT = 1.79769e308
const MIN_FLOAT = -1.79769e308

func get_children_of_type(node: Node, type) -> Array[Node]:
	var children: Array[Node] = []
	
	for child in node.get_children():
		if is_instance_of(child, type):
			children.append(child)
	
	return children


func get_first_child_of_type(node: Node, type) -> Node:
	for child in node.get_children():
		if is_instance_of(child, type):
			return child
	return null


func has_child_of_type(node: Node, type) -> bool:
	return get_first_child_of_type(node, type) != null
