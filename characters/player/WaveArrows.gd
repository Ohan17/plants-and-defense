extends Node2D

@onready var spawner = get_tree().get_nodes_in_group("Spawner")[0]
#@onready var player = get_tree().get_nodes_in_group("Player")[0]

var tracking : bool = false
var spawners : Array[Marker2D]
var nr_active : int

@export var dist_to_player : float = 8.0

func _ready():
	spawner.wave_directions_chosen.connect(show_wave_directions)
	modulate = Color(1.0,1.0,1.0,0.0)
	Global.night_started.connect(hide_wave_directions)


func show_wave_directions(_spawners,_nr_active):
	tracking = true
	spawners = _spawners
	nr_active = _nr_active
	modulate = Color(1.0,1.0,1.0,1.0)
	for i in range(get_child_count()):
		get_child(i).set_visible(i < nr_active)#.modulate = Color(1.0,1.0,1.0,1.0)


func hide_wave_directions():
	await get_tree().create_timer(1).timeout
	var tw = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self,"modulate",Color(1.0,1.0,1.0,0.0),1)
	await tw.finished
	tracking = false

func _process(_delta):
	if not tracking:
		return
	for i in range(nr_active):
		var dir = spawners[i].global_position - get_parent().global_position
		get_child(i).global_position =  get_parent().global_position + dir.normalized()*dist_to_player
		get_child(i).rotation = floor((atan2(dir.y,dir.x)-PI/4.0)/(PI*0.5) +PI/4.0)*PI*0.5
