extends MarginContainer

@onready var health_bar = $HBoxContainer2/LifeBar
@onready var dur_bar = $HBoxContainer2/DurabilityBar
@onready var resource_label = $HBoxContainer/ResourceLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../..".health_updated.connect(update_health)
	Global.resources_updated.connect(update_resource_label)
	$"../../../WeaponHolder".durability_updated.connect(update_dur)
	
func update_health(perc_health : float) -> void:
	health_bar.value = perc_health
	
func update_dur(perc_dur : float) -> void:
	dur_bar.set_visible(perc_dur > 0)
	dur_bar.value = perc_dur
	
func update_resource_label(val : int) -> void:
	resource_label.text = str(val)



