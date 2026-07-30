class_name Player
extends CharacterBody2D
## TESTING: Keep iterating this script to achieve a better controller

@export_category("Movement Parameters")
@export var horizontal_speed : float = 100.0
@export var jump_height : float = 42.0
@export var additional_jump : int = 1
@export var jump_cut_percentage : float = 0.5

@export_category("Gravity Multiplier Parameters")
@export var upward_movement_multi : float = 1.0
@export var downward_movement_multi : float = 2.0
@export var default_movement_multi : float = 1.0

# horizontal calculations
var horizontal_direction : float
var desired_velocity : Vector2

# jump variables for calculation
var was_on_floor : bool = false
var is_pressing_jump : bool
var is_jumping : bool
var jump_phase : int

# rigid body velocity cache for calculations
var player_velocity : Vector2

# cache gravity
var gravity : float

@onready var jump_buffer_timer: Timer = %JumpBufferTimer
@onready var coyote_timer: Timer = %CoyoteTimer

func _ready() -> void:
	# gravity = get_gravity() for some reason returns a Vector2.Zero ???????????????????
	# and this method returns a float ????????????????????
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta: float) -> void:
	_horizontal_movement()

func _physics_process(delta: float) -> void:
	player_velocity = velocity
	_run()
	if (is_on_floor() && velocity.y == 0): 
		jump_phase = 0
		is_jumping = false
	elif (was_on_floor):
		coyote_timer.start()
	was_on_floor = is_on_floor()

	if (!jump_buffer_timer.is_stopped()): 
		_jump()

	if (!is_on_floor()): # miss Unity rigidBody2D...
		var gravity_multi : float = _calculate_gravity()
		player_velocity.y += gravity * gravity_multi * delta 
	velocity = player_velocity
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("jump")):
		jump_buffer_timer.start()
		is_pressing_jump = true
	if (event.is_action_released("jump")):
		is_pressing_jump = false
		_cut_jump()

#region Gravity Calculations
func _calculate_gravity() -> float:
	if (is_pressing_jump && player_velocity.y < 0.0): 
		return upward_movement_multi
	elif (!is_pressing_jump || player_velocity.y > 0.0): 
		return downward_movement_multi
	else:
		return default_movement_multi
#endregion
#region Vertical Movement
func _jump() -> void:
	if (is_on_floor() || !coyote_timer.is_stopped() || (jump_phase < additional_jump && is_jumping)):
		coyote_timer.stop()
		if (is_jumping):
			jump_phase += 1 
		var jump_speed : float = sqrt(2.0 * gravity * jump_height * upward_movement_multi) # formula de vf = (2gh)^1/2
		is_jumping = true
		if (player_velocity.y < 0.0): 
			jump_speed = maxf(jump_speed + player_velocity.y, 0.0)
		elif (player_velocity.y > 0.0):
			jump_speed += abs(velocity.y)
		player_velocity.y -= jump_speed	

func _cut_jump() -> void:
	if (velocity.y < 0.0):
		velocity.y *= jump_cut_percentage
#endregion
#region Horizontal Movement
func _horizontal_movement() -> void:
	horizontal_direction = Input.get_axis("move_left", "move_right")
	desired_velocity.x = horizontal_direction * horizontal_speed

func _run() -> void:
	player_velocity.x = desired_velocity.x
	velocity = player_velocity
#endregion
