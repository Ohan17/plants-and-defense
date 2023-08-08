extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.resources_updated.connect(update_label)

func update_label(val : int) -> void:
	text = str(val)

