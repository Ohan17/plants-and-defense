extends ColorRect


@onready var rich_text = $MarginContainer/VBoxContainer/RichTextLabel
var dialogue_dict : Dictionary = {1:"[color=Green]Trader: [/color]
Hi there!
I see you are in a pickle.
I offer my service to you for the right price of course.
Press [color=Green][RMB][/color] anywhere to open my shop.",
2:"[color=Green]Trader: [/color]
The top right symbol in the shop tells you its plant category. 
Sword means offensive. Shield means defensive. Ring means equipable weapon.
Once fully grown you can pick up equipment plants with [color=Green][E][/color].
Also plants take time to fully grow indicated by the hourglass symbol.",
3:"[color=Green]Trader: [/color]
You may see plants with a green cost. This is my daily deal, where it`s 1 gem cheaper.",
4:"[color=Green]Trader: [/color]
The dropped gems are quite valuable to me.
Not many can say, they own essence gems of the lich`s minions.",
7:"[color=Green]Trader: [/color]
Beware the old lich is sending the [color=Red]big guys[/color] tomorrow.",
8:"[color=Green]Trader: [/color]
I hope you are prepared for what`s to come.",
9:"[color=Green]Trader: [/color]
You should have paid your taxes.
Nothing jolly about fearing for your life.",
11:"[color=Green]Trader: [/color]
Wow you are formidable. Most didn`t last this long.",
12:"[color=Green]Trader: [/color]
I hope you don`t rot in a cell, when they finally get you.",
15:"[color=Green]Trader: [/color]
You are a legend.",
25:"You should probably stop now."
}

var current_dialogue : String = ""

func _ready():
	Global.day_started.connect(prepare_dialogue)

func prepare_dialogue():
	if Global.day in dialogue_dict.keys():
		current_dialogue = dialogue_dict[Global.day]
		rich_text.scroll_to_line(0)
	else:
		current_dialogue = "Good Luck."

	
func open_dialogue():
	SfxPlayer.play("res://assets/audio/click.wav")
	show()
	rich_text.text = current_dialogue
	


func _on_prepare_button_button_up():
	SfxPlayer.play("res://assets/audio/click.wav")
	hide()
