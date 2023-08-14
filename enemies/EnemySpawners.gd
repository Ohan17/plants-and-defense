extends Node2D

@onready var spawners :Array[Marker2D]= [$SpawnerNorth, $SpawnerSouth, $SpawnerWest, $SpawnerEast]
var nr_of_directions : int = 0
var spawn_interval : float = 1.5
var is_spawning : bool = false
var current_wave : Dictionary
@onready var enemy_dict = {"StandardEnemy" : "res://enemies/StandardEnemy.tres", 
"FastEnemy" : "res://enemies/FastEnemy.tres",
"RushEnemy" : "res://enemies/RushEnemy.tres",
"BigEnemy" : "res://enemies/BigEnemy.tres"}

#var wave_list = []

@onready var enemy_temp = preload("res://enemies/enemy_template.tscn")
var last_reported_enemy_count : int = 100
var last_kill_count : int = 0
var wave_enemy_count : int = 1

var spawn_time = 1.5
signal wave_directions_chosen


func _ready():
	Global.day_started.connect(choose_spawns)
	Global.night_started.connect(start_wave)


func start_wave():
	is_spawning = true

func choose_spawns():
	nr_of_directions = clamp(int(floor(Global.day/4.0)) + 1,1,4)
	spawners.shuffle()
	current_wave = calculate_next_wave(Global.day)
	wave_enemy_count = nr_of_wave_left_to_spawn(current_wave)
	emit_signal("wave_directions_chosen",spawners,nr_of_directions)

func _process(delta):
	if not is_spawning:
		return
	spawn_time -= delta
	if spawn_time < 0:
		##spawn enemy
		for i in range(nr_of_directions):
			var new_en_key = get_rand_enemy(current_wave)
			current_wave[new_en_key] -= 1
			var new_en = enemy_temp.instantiate()
			add_child(new_en)
			
			var rand_angle = randf()*2*PI
			var rand_spawn_off = 10*randf()*Vector2(sin(rand_angle), cos(rand_angle))
			var spawn_pos = spawners[i].global_position + rand_spawn_off
			new_en.global_position = spawn_pos
			new_en.initialize(load(enemy_dict[new_en_key]))
			new_en.enemy_cleared.connect(_on_enemy_cleared)
			
			if nr_of_wave_left_to_spawn(current_wave) < 1:
				is_spawning = false
				return
			
		spawn_time = spawn_interval
	
		
#### Calculate the amount of which enemy there should be in the next wave
func calculate_next_wave(day_nr : int) -> Dictionary:
	var new_wave = {}
	new_wave["StandardEnemy"] = clamp((1 + 2*day_nr) - int(day_nr > 7)*2*(day_nr-7),0,15)
	new_wave["FastEnemy"] = clamp(2*(day_nr-2) + int(day_nr%2)- int(day_nr > 10)*(2*(day_nr - 10)), 0, 17)
	new_wave["RushEnemy"] = clamp(2*(day_nr-4)*int(day_nr < 8) + int(day_nr >= 8)*(8 + 3*(day_nr-7)),0,20)
	new_wave["BigEnemy"] = clamp(day_nr - 7,0,25)
	return new_wave
	
func nr_of_wave_left_to_spawn(c_wave : Dictionary)-> int:
	var sum : int = 0
	for i in c_wave.values():
		sum += i
	return sum
	
func get_rand_enemy(c_wave : Dictionary)-> String:
	var chosen_enemy : String = ""
	var pos_wave = c_wave.values().filter(func(val): return val > 0)
	chosen_enemy = c_wave.find_key(pos_wave.pick_random()) ###not optimal when having multiple keys with same value
	return chosen_enemy


func _on_enemy_cleared() -> void:
	if !is_spawning and Enemy.count == 0:
		Global.start_day()
