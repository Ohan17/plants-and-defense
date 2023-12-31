class_name TilePointer
extends Sprite2D


static var tile: Vector2i
static var tile_position: Vector2

@export var player: Player

func _ready():
	Global.night_started.connect(hide)
	Global.day_started.connect(show)


func _process(_delta: float) -> void:
	set_visible(Global.is_placing)
	var player_tile: Vector2i = Map.global_to_map(player.global_position)
	tile = Map.global_to_map(get_global_mouse_position()).clamp(
		player_tile - Vector2i.ONE, player_tile + Vector2i.ONE
	)
	tile_position = Map.map_to_global(tile)
	global_position = tile_position
