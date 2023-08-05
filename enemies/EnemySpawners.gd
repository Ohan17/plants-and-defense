extends Node2D

@onready var spawners :Array[Marker2D]= [$SpawnerNorth, $SpawnerSouth, $SpawnerWest, $SpawnerEast]
var active_spawns : int = 0
var spawn_interval : float = 1.5
var is_spawning : bool = false
var current_wave : Dictionary
var fast_enemy_start_day : int = 3
@onready var enemy_dict = {"StandardEnemy" : "res://enemies/StandardEnemy.tres", "FastEnemy":"res://enemies/FastEnemy.tres"}
@onready var enemy_temp = preload("res://enemies/enemy_template.tscn")

var spawn_time = 1.5
signal spawning_over


func _ready():
	Global.night_started.connect(start_wave.bind(Global.day))

func start_wave(cur_day : int):
	var nr_of_directions : int = clamp(floor(cur_day/4.0) + 1,1,4)
	choose_spawns(nr_of_directions)
	is_spawning = true

func choose_spawns(to_activate : int):
	spawners.shuffle()
	active_spawns = to_activate
	current_wave = calculate_next_wave(Global.day)
	print(current_wave)

func _process(delta):
	if not is_spawning:
		return
	spawn_time -= delta
	if spawn_time < 0:
		##spawn enemy
		for i in range(active_spawns):
			if nr_of_wave_left(current_wave) < 1:
				emit_signal("spawning_over")
				is_spawning = false
				return
				
			var new_en_key = get_rand_enemy(current_wave)
			current_wave[new_en_key] -= 1
			var new_en = enemy_temp.instantiate()
			add_child(new_en)
			new_en.initialize(load(enemy_dict[new_en_key]))
			
			
			var rand_angle = randf()*2*PI
			var rand_spawn_off = 10*randf()*Vector2(sin(rand_angle), cos(rand_angle))
			var spawn_pos = spawners[i].global_position + rand_spawn_off
			
			new_en.global_position = spawn_pos
		spawn_time = spawn_interval
	
		
#### Calculate the amount of which enemy there should be in the next wave
func calculate_next_wave(day_nr : int) -> Dictionary:
	var new_wave = {}
	new_wave["StandardEnemy"] = min(5 + 2*day_nr, 25)
	new_wave["FastEnemy"] = clamp((day_nr - fast_enemy_start_day + 1)*2 , 0, 25) +3
	return new_wave
	
func nr_of_wave_left(c_wave : Dictionary)-> int:
	var sum : int = 0
	for i in c_wave.values():
		sum += i
	return sum
	
func get_rand_enemy(c_wave : Dictionary)-> String:
	var chosen_enemy : String = ""
	var pos_wave = c_wave.values().filter(func(val): return val > 0)
	chosen_enemy = c_wave.find_key(pos_wave.pick_random()) ###not optimal when having multiple keys with same value
	return chosen_enemy

