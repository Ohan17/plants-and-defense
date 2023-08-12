extends MarginContainer


@onready var health_bar = $HBoxContainer2/LifeBar
@onready var dur_bar = $HBoxContainer2/DurabilityBar
@onready var resource_label = $HBoxContainer/ResourceLabel


func _ready():
	Player.instance.health_updated.connect(update_health)
	Player.instance.get_node("%WeaponHolder").durability_updated.connect(update_dur)
	Global.resources_updated.connect(update_resource_label)
	update_resource_label(Global.resources)


func update_health(perc_health : float) -> void:
	health_bar.value = perc_health


func update_dur(perc_dur : float) -> void:
	dur_bar.set_visible(perc_dur > 0)
	dur_bar.value = perc_dur


func update_resource_label(val : int) -> void:
	resource_label.text = str(val)
