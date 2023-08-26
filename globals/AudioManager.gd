extends Node

@onready var players : Array[AudioStreamPlayer]
var curr_player : int = 0

func _ready():
	for i in range(2):
		var new_p = AudioStreamPlayer.new()
		new_p.bus = "Music"
		add_child(new_p)
		players.append(new_p)

func play_music(path : String, transition_time : float = 2.0):
	curr_player = (curr_player + 1)%2
	players[curr_player].stream = load(path)
	players[curr_player].volume_db = -80.0
	players[curr_player].play()
	var tw = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tw.tween_property(players[curr_player],"volume_db",0.0,transition_time)
	tw.tween_property(players[(curr_player + 1)%2],"volume_db",-80.0,transition_time)
