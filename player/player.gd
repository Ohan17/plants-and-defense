class_name Player
extends CharacterBody2D


const SPEED: float = 30.0

func _physics_process(delta: float):

	var direction := Input.get_vector("left", "right", "forward", "backward")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

