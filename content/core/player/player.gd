class_name Player
extends CharacterBody2D


#TODO improve player controller
@export var speed : float = 300.0
@export var deceleration : float = 140.0
@export var jump_force : float = 500.0

var horizontal_direction : float
var desired_jump : bool = false



func _physics_process(delta: float) -> void:
	if (!is_on_floor()):
		velocity.y += get_gravity().y * delta;
		
	if (desired_jump && is_on_floor()):
		jump(delta)
		desired_jump = false

	horizontal_direction = Input.get_axis("move_left", "move_right")
	if (horizontal_direction):
		velocity.x = horizontal_direction * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("jump") && is_on_floor()):
		desired_jump = true

func jump(delta : float) -> void:
	velocity.y -= jump_force * delta
