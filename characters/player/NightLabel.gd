extends Label

func _ready():
	Global.night_started.connect(update_label)


func update_label():
	
	var tw = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self,"position",Vector2(12,1),0.7)
	text = "Night " + str(Global.day)
	await tw.finished
	await get_tree().create_timer(1.5).timeout
	
	tw = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self,"position",Vector2(74,1),0.7)
	await tw.finished
	position = Vector2(12,-10)
	
