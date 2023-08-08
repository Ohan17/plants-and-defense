extends Node

### Used for playing sound effects once
### Good for playing destruction sounds, where the node is freed
### I dont know if we need positional audio, so change if unnecessary

@onready var MAX_PLAYERS : int = 12
@onready var available_players : Array[AudioStreamPlayer2D]

func _ready():
	for i in range(MAX_PLAYERS):
		var new_player = AudioStreamPlayer2D.new()
		get_tree().root.call_deferred("add_child",new_player)
		available_players.append(new_player)
		new_player.finished.connect(sfx_finished.bind(new_player))

## plays a single soundeffect at given position
func play(audio_path : String, pos : Vector2):
	if available_players.is_empty():
		return
	var pl = available_players.pop_front()
	pl.stream = load(audio_path)
	pl.global_position = pos
	pl.pitch_scale = randf()*0.2 + 0.9
	pl.play()
		
func sfx_finished(player_fin : AudioStreamPlayer2D):
	available_players.append(player_fin)
