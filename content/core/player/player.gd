class_name Player
extends CharacterBody2D

#TODO improve player controller
@export var speed : float = 100.0
@export var jump_height : float = 42.0 # pixels
@export var upward_movement_multi : float = 1.0
@export var downward_movement_multi : float = 2.0

# cache gravity
var gravity : float

# horizontal movement variables
var horizontal_direction : float
var desired_velocity : Vector2

# jump variables
var is_pressing_jump : bool
var desired_jump : bool
var is_jumping : bool

# rigid body velocity variable for calculations
var player_velocity : Vector2

func _ready() -> void:
	# gravity = get_gravity() for some reason returns a Vector2.Zero ???????????????????
	# and this method returns a float ????????????????????
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta: float) -> void:
	_horizontal_movement()

func _physics_process(delta: float) -> void:
	player_velocity = velocity
	_run() # pensar se devo aplicar air movement
	
	if (is_on_floor() && velocity.y == 0):  # esta no chao e nao esta pulando
		is_jumping = false

	if (desired_jump): # esta querendo pular entao pula
		desired_jump = false
		_jump()

	if (!is_on_floor()): # miss Unity rigidBody2D...
		var gravity_multi : float = 1.0
		gravity_multi = _calculate_gravity(gravity_multi)
		player_velocity.y += gravity * gravity_multi * delta 
	velocity = player_velocity
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("jump")):
		desired_jump = true

func _calculate_gravity(gravity_multi : float) -> float:
	if (is_pressing_jump && player_velocity.y < 0.0):
		gravity_multi = upward_movement_multi
	elif (!is_pressing_jump && player_velocity.y > 0.0):
		gravity_multi = downward_movement_multi
	return gravity_multi


func _jump() -> void:
	var jump_speed : float = sqrt(2.0 * gravity * jump_height * upward_movement_multi) # formula de vf = (2gh)^1/2
	is_jumping = true
	if (player_velocity.y < 0.0): # isso aqui é mais pra pulo duplo...
		jump_speed = maxf(jump_speed + player_velocity.y, 0.0)
	elif (player_velocity.y > 0.0):
		jump_speed += abs(velocity.y)
	print("jump speed: " + str(jump_speed))
	player_velocity.y -= jump_speed	

#region Horizontal Movement
func _horizontal_movement() -> void:
	horizontal_direction = Input.get_axis("move_left", "move_right")
	desired_velocity.x = horizontal_direction * speed

func _run() -> void:
	player_velocity.x = desired_velocity.x
	velocity = player_velocity
#endregion
