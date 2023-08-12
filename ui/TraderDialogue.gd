extends ColorRect

@export var text_sound : String 
@onready var rich_text = $MarginContainer/RichTextLabel
var has_talked : bool = false
var dialogue_dict : Dictionary = {1:"[color=Blue]Trader: [/color]
Hi there!
I see you have a problem on your hand.
I could help you with this issue. For the right price of course."
}

var current_dialogue : String = ""

func _ready():
	Global.day_started.connect(prepare_dialogue)

func prepare_dialogue():
	if Global.day in dialogue_dict.keys():
		current_dialogue = dialogue_dict[Global.day]
	else:
		current_dialogue = ""
	has_talked = false
	
func open_dialogue():
	if has_talked:
		return
	rich_text.text = current_dialogue
	
	has_talked = true
