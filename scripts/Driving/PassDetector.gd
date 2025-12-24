extends Node2D

var last_traffic_positions: Dictionary = {}  # car_id -> position
var passed_cars: Array[int] = []

func _ready():
	add_to_group("pass_detector")

func _process(_delta):
	var player_car = get_tree().get_first_node_in_group("player_car")
	if not player_car:
		return
	
	var traffic_cars = get_tree().get_nodes_in_group("traffic_car")
	var player_pos = player_car.global_position
	
	for car in traffic_cars:
		if not car or not is_instance_valid(car):
			continue
		
		var car_id = car.get_instance_id()
		var car_pos = car.global_position
		
		if car_id in last_traffic_positions:
			var last_pos = last_traffic_positions[car_id]
			# Check if player passed this car
			var player_behind = (player_pos - last_pos).dot((car_pos - last_pos).normalized()) < 0
			var player_ahead_now = (player_pos - car_pos).dot((car_pos - last_pos).normalized()) > 0
			
			if player_behind and player_ahead_now and car_id not in passed_cars:
				_award_pass(car)
				passed_cars.append(car_id)
		
		last_traffic_positions[car_id] = car_pos

func _award_pass(car: Node):
	var score_manager = get_tree().get_first_node_in_group("score_manager")
	if score_manager:
		score_manager.award_pass()
