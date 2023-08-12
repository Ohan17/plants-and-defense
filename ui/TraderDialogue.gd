extends ColorRect


@onready var rich_text = $MarginContainer/VBoxContainer/RichTextLabel
var dialogue_dict : Dictionary = {1:"[color=Blue]Trader: [/color]
Hi there!
I see you have a problem on your hand.
I could help you with this issue. For the right price of course.
Press [RMB] anywhere to open my shop."
}

var current_dialogue : String = ""

func _ready():
	Global.day_started.connect(prepare_dialogue)

func prepare_dialogue():
	if Global.day in dialogue_dict.keys():
		current_dialogue = dialogue_dict[Global.day]
	else:
		current_dialogue = ""

	
func open_dialogue():
	show()
	rich_text.text = current_dialogue
	


func _on_prepare_button_button_up():
	hide()
