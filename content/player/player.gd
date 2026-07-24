extends CharacterBody2D


const SPEED : float = 300.0

var horizontal_direction : float

func _physics_process(_delta: float) -> void:
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else: 
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("move_left") || event.is_action("move_right"):
		horizontal_direction = Input.get_axis("move_left", "move_right")
