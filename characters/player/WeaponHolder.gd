extends Marker2D

@export var distance_to_player : float = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_pos = get_parent().global_position
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - player_pos
	if direction.length() > 3:
		direction = direction.normalized()
		show_behind_parent = direction.y < 0
		position = distance_to_player*direction
