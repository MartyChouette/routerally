extends Node2D

@export var traffic_car_scene: PackedScene = preload("res://scenes/AI/TrafficCar.tscn")
@export var max_traffic_cars: int = 5
@export var spawn_interval: float = 3.0

var traffic_cars: Array[Node] = []
var spawn_timer: float = 0.0
var path_points: Array[Vector2] = []

func _ready():
	# Generate path points from tile map
	_generate_path_from_tiles()

func _process(delta):
	spawn_timer += delta
	
	if traffic_cars.size() < max_traffic_cars and spawn_timer >= spawn_interval:
		spawn_traffic_car()
		spawn_timer = 0.0

func _generate_path_from_tiles():
	# This would ideally read from the tile map to generate a path
	# For now, create a simple loop
	var base_pos = Vector2(0, 0)
	var spacing = 200.0
	path_points = [
		base_pos + Vector2(0, 0),
		base_pos + Vector2(spacing * 2, 0),
		base_pos + Vector2(spacing * 2, spacing * 2),
		base_pos + Vector2(0, spacing * 2),
	]

func spawn_traffic_car():
	if not traffic_car_scene or path_points.size() == 0:
		return
	
	var car = traffic_car_scene.instantiate()
	add_child(car)
	car.position = path_points[0]
	if car.has_method("set_path_points"):
		car.set_path_points(path_points)
	traffic_cars.append(car)

func remove_traffic_car(car: Node):
	if car in traffic_cars:
		traffic_cars.erase(car)
		car.queue_free()
