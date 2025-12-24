extends CharacterBody2D

@export var speed: float = 300.0
@export var path_points: Array[Vector2] = []

var current_path_index: int = 0
var target_position: Vector2

func set_path_points(points: Array[Vector2]):
	path_points = points
	if path_points.size() > 0:
		target_position = path_points[0]
		current_path_index = 0

func _ready():
	if path_points.size() > 0:
		target_position = path_points[0]

func _physics_process(delta):
	if path_points.size() == 0:
		return
	
	var distance_to_target = global_position.distance_to(target_position)
	
	if distance_to_target < 10.0:
		current_path_index = (current_path_index + 1) % path_points.size()
		target_position = path_points[current_path_index]
	
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	
	if velocity.length() > 0:
		rotation = lerp_angle(rotation, velocity.angle(), delta * 5.0)
	
	move_and_slide()
