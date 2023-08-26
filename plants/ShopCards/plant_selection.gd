extends NinePatchRect

@export var PlantCardList : Array[PlantCardResource]
@onready var current_card_ind : int = 0
@export var plant_types : Array[Texture2D]
@export var buy_sound : String = "res://assets/audio/pickupCoin.wav"
@export var change_sound : String = "res://assets/audio/click.wav"

@export var plant_card : PlantCardResource
@onready var is_in_shop : bool = false

var shop_sound : String = "res://assets/audio/Coin_Collect.ogg"
@export var namelabel : Label
@export var typeicon : TextureRect
@export var portrait : TextureRect
@export var costlabel : Label
@export var timelabel : Label
@export var buybutton : Button
@export var desclabel : Label


var discount_ind : int = 0
var is_discounted : int = 0
### emit signal with FilePath of purchased plant
signal plant_purchased

func _ready():
	update_card()
	#$VBoxContainer/BuyButton.button_up.connect()
	$AnimationPlayer.play("Blinking")
	$PlantSelectionScreen/VBoxContainer/HBoxContainer2/PrevButton.button_up.connect(change_card.bind(-1))
	$PlantSelectionScreen/VBoxContainer/HBoxContainer2/NextButton.button_up.connect(change_card.bind(1))
	buybutton.button_up.connect(buy_plant)
	
	plant_purchased.connect(get_tree().get_nodes_in_group("Level")[0].plant_to_place)
	Global.day_started.connect(_random_discount)
	
func _input(_event):
	if Input.is_action_just_pressed("rmb") and not Global.is_placing and Global.is_day and Global.shop_unlocked:
		is_in_shop = !is_in_shop
		set_visible(is_in_shop)
		update_card()
		SfxPlayer.play(shop_sound)
		
		
func change_card(val : int) -> void:
	current_card_ind = pos_mod(current_card_ind + val,PlantCardList.size())
	update_card()
	SfxPlayer.play(change_sound)

func update_card() -> void:
	namelabel.text = PlantCardList[current_card_ind].plant_name
	typeicon.texture = plant_types[PlantCardList[current_card_ind].plant_type]
	portrait.texture = PlantCardList[current_card_ind].portrait
	is_discounted =  int(discount_ind == current_card_ind)
	costlabel.self_modulate = Color(1.0-is_discounted,1.0,1.0-is_discounted,1.0)
	costlabel.text = str(max(0,PlantCardList[current_card_ind].cost - is_discounted)) + "(" + str(Global.resources) +")"
	timelabel.text = str(PlantCardList[current_card_ind].growthtime) + "d"
	buybutton.disabled = !Global.has_resource(PlantCardList[current_card_ind].cost-is_discounted)
	desclabel.text = PlantCardList[current_card_ind].plant_description

func buy_plant() -> void:
	#Global.remove_resource(max(0,PlantCardList[current_card_ind].cost - is_discounted))
	emit_signal("plant_purchased",PlantCardList[current_card_ind].plantPath,PlantCardList[current_card_ind].cost,is_discounted)
	SfxPlayer.play(buy_sound)
	disable_discount(is_discounted)
	is_in_shop = !is_in_shop
	set_visible(is_in_shop)
	Global.is_placing = true

func _random_discount() -> void:
	discount_ind = randi_range(0,PlantCardList.size()-1)
	
func disable_discount(val : int) -> void:
	if val > 0:
		discount_ind = -1000

func pos_mod(a : int, b : int) -> int:
	return a - floor(float(a)/float(b)) * b
