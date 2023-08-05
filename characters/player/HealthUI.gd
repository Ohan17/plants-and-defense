extends Control

@onready var health_bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../..".health_updated.connect(update_ui)

func update_ui(perc_health : float):
	health_bar.value = perc_health
