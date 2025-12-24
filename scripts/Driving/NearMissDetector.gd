extends Area2D

func _ready():
	add_to_group("near_miss_detector")

@export var near_miss_distance: float = 50.0
@export var cooldown_time: float = 1.0

var nearby_cars: Array[Node] = []
var cooldown_timer: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	cooldown_timer = max(0.0, cooldown_timer - delta)
	
	if cooldown_timer <= 0.0 and nearby_cars.size() > 0:
		# Check for near miss
		for car in nearby_cars:
			if car and is_instance_valid(car):
				var distance = global_position.distance_to(car.global_position)
				if distance < near_miss_distance and distance > 20.0:
					_award_near_miss()
					cooldown_timer = cooldown_time
					break

func _on_body_entered(body: Node2D):
	if body.is_in_group("traffic_car"):
		nearby_cars.append(body)

func _on_body_exited(body: Node2D):
	if body in nearby_cars:
		nearby_cars.erase(body)

func _award_near_miss():
	var score_manager = get_tree().get_first_node_in_group("score_manager")
	if score_manager:
		score_manager.award_near_miss()
