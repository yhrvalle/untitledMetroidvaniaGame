class_name Player
extends CharacterBody2D

#TODO: jump buffer, coyote time
# coyote time provavelmente vai usar o node de Timer !!!
@export var speed : float = 100.0
@export var jump_height : float = 42.0 # pixels
@export var additional_jump : int = 1

# cache gravity
var gravity : float
# gravity scale
var upward_movement_multi : float = 1.0
var downward_movement_multi : float = 2.0
var default_movement_multi : float = 1.0
# horizontal movement variables
var horizontal_direction : float
var desired_velocity : Vector2

# jump variables
var is_pressing_jump : bool
var desired_jump : bool
var is_jumping : bool
var jump_phase : int
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
		jump_phase = 0
		is_jumping = false

	if (desired_jump): # esta querendo pular entao pula
		desired_jump = false
		_jump()

	if (!is_on_floor()): # miss Unity rigidBody2D...
		var gravity_multi : float = _calculate_gravity()
		player_velocity.y += gravity * gravity_multi * delta 
	velocity = player_velocity
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("jump")):
		desired_jump = true
		is_pressing_jump = true
	if (event.is_action_released("jump")):
		is_pressing_jump = false

#region Vertical Movement
func _calculate_gravity() -> float:
	if (is_pressing_jump && velocity.y < 0.0): 
		return upward_movement_multi
	elif (!is_pressing_jump || velocity.y > 0.0): # parou de segurar o botao ou ESTÁ DESCENDO
		# GODOT Y AXIS É INVERTIDO
		return downward_movement_multi
	else:
		return default_movement_multi

func _jump() -> void:
	# esse is on floor vira condicao de coyote time
	if (is_on_floor() || (is_jumping && jump_phase < additional_jump)):
		if (is_jumping):
			jump_phase += 1 

		var jump_speed : float = sqrt(2.0 * gravity * jump_height * upward_movement_multi) # formula de vf = (2gh)^1/2
		is_jumping = true
		if (player_velocity.y < 0.0): # isso aqui é mais pra pulo duplo...
			jump_speed = maxf(jump_speed + player_velocity.y, 0.0)
		elif (player_velocity.y > 0.0):
			jump_speed += abs(velocity.y)
		print("jump speed: " + str(jump_speed))
		player_velocity.y -= jump_speed	
#endregion

#region Horizontal Movement
func _horizontal_movement() -> void:
	horizontal_direction = Input.get_axis("move_left", "move_right")
	desired_velocity.x = horizontal_direction * speed

func _run() -> void:
	player_velocity.x = desired_velocity.x
	velocity = player_velocity
#endregion
