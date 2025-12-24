extends CharacterBody2D

@export var max_speed: float = 500.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0
@export var drift_friction: float = 200.0
@export var turn_rate: float = 5.0
@export var drift_threshold: float = 0.7
@export var drift_angle_max: float = 0.5

var current_speed: float = 0.0
var drive_input: Vector2 = Vector2.ZERO
var is_drifting: bool = false
var drift_angle: float = 0.0
var last_position: Vector2
var distance_traveled: float = 0.0
var drift_distance: float = 0.0
var last_drive_input: Vector2 = Vector2.ZERO
var drift_cooldown: float = 0.0

signal drift_started
signal drift_ended
signal distance_traveled_changed(distance: float)

func _ready():
	last_position = global_position

func _physics_process(delta):
	# Get input direction (single stick control)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir.length() > 0.1:
		drive_input = input_dir.normalized()
	else:
		# If no input, maintain last direction but slow down
		if drive_input.length() < 0.1:
			drive_input = velocity.normalized() if velocity.length() > 10 else Vector2.ZERO
	
	var brake_input = Input.is_action_pressed("brake")
	
	# Calculate speed
	if drive_input.length() > 0.1:
		if brake_input and current_speed > 50:
			# Braking while moving - reduce speed faster
			current_speed = move_toward(current_speed, 0, friction * delta * 2.0)
		else:
			current_speed = move_toward(current_speed, max_speed, acceleration * delta)
	else:
		current_speed = move_toward(current_speed, 0, friction * delta)
	
	# Check for drift (sudden direction change + brake)
	var current_vel_dir = velocity.normalized() if velocity.length() > 10 else drive_input
	var input_change = drive_input - current_vel_dir
	var sudden_turn = input_change.length() > drift_threshold
	
	drift_cooldown = max(0.0, drift_cooldown - delta)
	
	if brake_input and sudden_turn and current_speed > 100 and drift_cooldown <= 0:
		if not is_drifting:
			is_drifting = true
			drift_started.emit()
		drift_angle = lerp(drift_angle, drift_angle_max * sign(input_change.cross(current_vel_dir)), delta * turn_rate * 2.0)
		current_speed = move_toward(current_speed, max_speed * 0.8, drift_friction * delta)
	else:
		if is_drifting:
			is_drifting = false
			drift_ended.emit()
			drift_cooldown = 0.2  # Small cooldown to prevent rapid drift toggling
		drift_angle = lerp(drift_angle, 0.0, delta * turn_rate * 3.0)
	
	# Calculate movement direction - smooth turning
	var target_dir = drive_input
	if current_speed > 50:
		# Smooth turning based on current velocity
		var turn_strength = clamp(input_change.length() * 2.0, 0.0, 1.0)
		target_dir = current_vel_dir.lerp(drive_input, turn_strength * delta * turn_rate)
	
	var move_dir = target_dir.rotated(drift_angle if is_drifting else 0.0)
	
	# Apply movement
	velocity = move_dir * current_speed
	move_and_slide()
	
	# Track distance and drift
	var movement = global_position - last_position
	distance_traveled += movement.length()
	if is_drifting:
		drift_distance += movement.length()
	
	last_position = global_position
	
	# Update rotation to face movement direction
	if velocity.length() > 10:
		rotation = lerp_angle(rotation, velocity.angle(), delta * turn_rate)
	
	last_drive_input = drive_input
