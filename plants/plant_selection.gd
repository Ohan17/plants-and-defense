extends MarginContainer

@export var PlantCardList : Array[PlantCardResource]
@onready var current_card_ind : int = 0
@export var plant_types : Array[Texture2D]

@export var plant_card : PlantCardResource
@onready var is_in_shop : bool = false

@export var namelabel : Label
@export var portrait : TextureRect
@export var costlabel : Label
@export var timelabel : Label
@export var buybutton : Button


func _ready():
	change_card(0)
	#$VBoxContainer/BuyButton.button_up.connect()
	$"../AnimationPlayer".play("Blinking")
	$VBoxContainer/HBoxContainer2/TextureRect2/Button.button_up.connect(change_card.bind(-1))
	$VBoxContainer/HBoxContainer2/TextureRect/Button2.button_up.connect(change_card.bind(1))
	
func _input(_event):
	if Input.is_action_just_pressed("rmb"):
		is_in_shop = !is_in_shop
		set_visible(is_in_shop)
		
		
func change_card(val : int) -> void:
	pass
	current_card_ind = (current_card_ind + val)%PlantCardList.size()
	$VBoxContainer/HBoxContainer/Plant_name.text = PlantCardList[current_card_ind].plant_name
	$VBoxContainer/HBoxContainer/PlantTypeIcon.texture = plant_types[PlantCardList[current_card_ind].plant_type]
	$VBoxContainer/HBoxContainer2/Plant_portrait.texture = PlantCardList[current_card_ind].portrait
	$VBoxContainer/GridContainer/CostLabel.text = str(PlantCardList[current_card_ind].cost)
	$VBoxContainer/GridContainer/GrowthtimeLabel.text = str(PlantCardList[current_card_ind].growthtime)
	$VBoxContainer/BuyButton.disabled = !Global.has_resource(PlantCardList[current_card_ind].cost)

func buy_plant():
	Global.remove_resource(PlantCardList[current_card_ind].cost)
	
	###
