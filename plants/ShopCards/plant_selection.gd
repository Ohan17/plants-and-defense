extends NinePatchRect

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


var discount_ind : int = 0
var is_discounted : int = 0.0
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
	if Input.is_action_just_pressed("rmb") and Global.is_day:
		is_in_shop = !is_in_shop
		set_visible(is_in_shop)
		update_card()
		
		
func change_card(val : int) -> void:
	current_card_ind = (current_card_ind + val)%PlantCardList.size()
	update_card()
	SfxPlayer.play(change_sound)

func update_card() -> void:
	namelabel.text = PlantCardList[current_card_ind].plant_name
	typeicon.texture = plant_types[PlantCardList[current_card_ind].plant_type]
	portrait.texture = PlantCardList[current_card_ind].portrait
	is_discounted =  int(discount_ind == current_card_ind)
	costlabel.self_modulate = Color(1.0-is_discounted,1.0,1.0-is_discounted,1.0)
	costlabel.text = str(PlantCardList[current_card_ind].cost - is_discounted) + "(" + str(Global.resources) +")"
	timelabel.text = str(PlantCardList[current_card_ind].growthtime) + "d"
	buybutton.disabled = !Global.has_resource(PlantCardList[current_card_ind].cost-is_discounted)
	#print(is_discounted)
	#print(current_card_ind)
	print(discount_ind)
	

func buy_plant() -> void:
	print(PlantCardList[current_card_ind].cost-int(is_discounted))
	Global.remove_resource(PlantCardList[current_card_ind].cost-int(is_discounted))
	emit_signal("plant_purchased",PlantCardList[current_card_ind].plantPath)
	SfxPlayer.play(buy_sound)
	is_in_shop = !is_in_shop
	set_visible(is_in_shop)
	#discount_ind = -1
	disable_discount(is_discounted)

func _random_discount() -> void:
	discount_ind = randi_range(0,PlantCardList.size()-1)
	
func disable_discount(val : int) -> void:
	if val > 0:
		discount_ind = -1
