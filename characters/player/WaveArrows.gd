extends Node2D

@onready var spawner = get_tree().get_nodes_in_group("Spawner")[0]
@onready var player = get_tree().get_nodes_in_group("Player")[0]

var tracking : bool = false
var spawners : Array[Marker2D]
var nr_active : int

@export var dist_to_player : float = 8.0

func _ready():
	#spawner = 
	spawner.wave_directions_chosen.connect(show_wave_directions)
	for i in get_children():
		i.modulate = Color(1.0,1.0,1.0,0.0)


func show_wave_directions(_spawners,_nr_active):
	print("dir chosen")
	tracking = true
	spawners = _spawners
	nr_active = _nr_active
	for i in range(nr_active):
		get_child(i).modulate = Color(1.0,1.0,1.0,1.0)
	await get_tree().create_timer(3).timeout
	var tw = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self,"modulate",Color(1.0,1.0,1.0,0.0),1)
	await tw.finished
	tracking = false


func _process(_delta):
	if not tracking:
		return
	for i in range(nr_active):
		var dir = spawners[i].global_position - player.global_position
		#var dir = spawners[i].position
		get_child(i).global_position =  player.global_position + dir.normalized()*dist_to_player
		get_child(i).rotation = atan2(dir.y,dir.x)
