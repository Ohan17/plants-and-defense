extends ColorRect

@export var PlantCardList : Array[PlantCardResource]
@onready var current_card_ind : int = 0
@export var plant_types : Array[Texture2D]
@export var buy_sound : String = "res://assets/audio/pickupCoin.wav"
@export var change_sound : String = "res://assets/audio/click.wav"

@export var plant_card : PlantCardResource
@onready var is_in_shop : bool = false

@export var namelabel : Label
@export var typeicon : TextureRect
@export var portrait : TextureRect
@export var costlabel : Label
@export var timelabel : Label
@export var buybutton : Button

### emit signal with FilePath of purchased plant
signal plant_purchased

func _ready():
	change_card(0)
	#$VBoxContainer/BuyButton.button_up.connect()
	$AnimationPlayer.play("Blinking")
	$PlantSelectionScreen/VBoxContainer/HBoxContainer2/TextureRect2/Button.button_up.connect(change_card.bind(-1))
	$PlantSelectionScreen/VBoxContainer/HBoxContainer2/TextureRect/Button2.button_up.connect(change_card.bind(1))
	buybutton.button_up.connect(buy_plant)
	#plant_purchased.connect(get_tree().get_nodes_in_group("Level")[0].new_plant)
	
func _input(_event):
	if Input.is_action_just_pressed("rmb") and Global.is_day:
		is_in_shop = !is_in_shop
		set_visible(is_in_shop)
		
		
func change_card(val : int) -> void:
	current_card_ind = (current_card_ind + val)%PlantCardList.size()
	namelabel.text = PlantCardList[current_card_ind].plant_name
	typeicon.texture = plant_types[PlantCardList[current_card_ind].plant_type]
	portrait.texture = PlantCardList[current_card_ind].portrait
	costlabel.text = str(PlantCardList[current_card_ind].cost) + "(" + str(Global.resources) +")"
	timelabel.text = str(PlantCardList[current_card_ind].growthtime)
	buybutton.disabled = !Global.has_resource(PlantCardList[current_card_ind].cost)
	SfxPlayer.play(change_sound)

func buy_plant():
	Global.remove_resource(PlantCardList[current_card_ind].cost)
	emit_signal("plant_purchased",PlantCardList[current_card_ind].plantPath)
	SfxPlayer.play(buy_sound)
	is_in_shop = !is_in_shop
	set_visible(is_in_shop)
