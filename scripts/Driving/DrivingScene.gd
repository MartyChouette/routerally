extends Node2D

@onready var player_car = $PlayerCar
@onready var tile_map = $TileMap
@onready var camera = $Camera2D
@onready var light_2d = $DirectionalLight2D
@onready var pause_menu = $UI/PauseMenu
@onready var lap_tracker = $LapTracker
@onready var score_manager = $ScoreManager

var is_paused: bool = false
var tile_placement_mode: bool = false
var selected_tile_type: String = "road_straight"
var time_speed: float = 0.1  # How fast time of day changes

func _ready():
	add_to_group("driving_scene")
	GameManager.change_state(GameManager.GameState.DRIVING)
	GameManager.time_of_day_changed.connect(_on_time_of_day_changed)
	player_car.drift_started.connect(_on_drift_started)
	player_car.drift_ended.connect(_on_drift_ended)
	if lap_tracker:
		lap_tracker.lap_completed.connect(_on_lap_completed)
	camera.position = player_car.position
	_update_lighting()

func _process(delta):
	# Update camera to follow player
	if player_car:
		camera.position = lerp(camera.position, player_car.position, delta * 5.0)
	
	# Check lap progress
	if lap_tracker and player_car:
		lap_tracker.check_player_position(player_car.global_position)
	
	# Gradually change time of day
	if not is_paused:
		var new_time = GameManager.time_of_day + time_speed * delta
		if new_time >= 1.0:
			new_time = 0.0
		GameManager.set_time_of_day(new_time)

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()
	
	# Tile placement
	if tile_placement_mode and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var world_pos = get_global_mouse_position()
			_place_tile_at_position(world_pos, selected_tile_type)
			tile_placement_mode = false
			get_tree().paused = false
			pause_menu.visible = false
			GameManager.change_state(GameManager.GameState.DRIVING)

func _place_tile_at_position(world_pos: Vector2, tile_type: String):
	# Convert tile type string to TileMap.TileType enum
	var tile_enum = TileMap.TileType.ROAD_STRAIGHT
	match tile_type:
		"road_straight":
			tile_enum = TileMap.TileType.ROAD_STRAIGHT
		"road_curve":
			tile_enum = TileMap.TileType.ROAD_CURVE
		"road_intersection":
			tile_enum = TileMap.TileType.ROAD_INTERSECTION
		"nature":
			tile_enum = TileMap.TileType.NATURE
		"mountain":
			tile_enum = TileMap.TileType.MOUNTAIN
	
	if tile_map:
		tile_map.place_tile_at_world_pos(world_pos, tile_enum)

func toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	pause_menu.visible = is_paused
	if is_paused:
		GameManager.change_state(GameManager.GameState.PAUSED)
	else:
		GameManager.change_state(GameManager.GameState.DRIVING)
		tile_placement_mode = false

func _on_time_of_day_changed(time: float):
	_update_lighting()

func _update_lighting():
	light_2d.direction = GameManager.light_direction
	# Adjust light color based on time of day
	var time = GameManager.time_of_day
	if time < 0.25 or time > 0.75:  # Night
		light_2d.color = Color(0.3, 0.3, 0.5, 1.0)
		light_2d.energy = 0.3
	elif time < 0.3 or time > 0.7:  # Dawn/Dusk
		light_2d.color = Color(1.0, 0.7, 0.5, 1.0)
		light_2d.energy = 0.6
	else:  # Day
		light_2d.color = Color(1.0, 1.0, 0.9, 1.0)
		light_2d.energy = 1.0

func _on_drift_started():
	pass

func _on_drift_ended():
	# Award money for drifting
	var drift_reward = int(player_car.drift_distance / 100.0)
	if drift_reward > 0:
		if score_manager:
			score_manager.award_drift(player_car.drift_distance)
		else:
			PlayerData.add_money(drift_reward)
		player_car.drift_distance = 0.0

func _on_lap_completed():
	if score_manager:
		score_manager.award_lap()
