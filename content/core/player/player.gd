class_name Player
extends CharacterBody2D

const SPEED : float = 300.0
const DECELERATION : float = 140.0
const JUMP_FORCE : float = 500.0

var horizontal_direction : float


func _physics_process(delta: float) -> void:
	if (!is_on_floor()):
		velocity.y += get_gravity().y * delta;

	horizontal_direction = Input.get_axis("move_left", "move_right")
	if (horizontal_direction):
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("jump") && is_on_floor()):
		jump()

func jump() -> void:
	velocity.y -= JUMP_FORCE
