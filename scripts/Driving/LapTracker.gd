extends Node2D

signal lap_completed

var checkpoints: Array[Vector2] = []
var current_checkpoint: int = 0
var lap_count: int = 0
var checkpoint_radius: float = 100.0

func _ready():
	# Initialize checkpoints from tile map or create default loop
	if checkpoints.size() == 0:
		_create_default_checkpoints()

func _create_default_checkpoints():
	# Create a simple rectangular checkpoint loop
	var base_pos = Vector2(0, 0)
	var spacing = 200.0
	checkpoints = [
		base_pos + Vector2(0, 0),
		base_pos + Vector2(spacing * 2, 0),
		base_pos + Vector2(spacing * 2, spacing * 2),
		base_pos + Vector2(0, spacing * 2),
	]

func check_player_position(player_pos: Vector2):
	if checkpoints.size() == 0:
		return
	
	var checkpoint_pos = checkpoints[current_checkpoint]
	var distance = player_pos.distance_to(checkpoint_pos)
	
	if distance < checkpoint_radius:
		current_checkpoint = (current_checkpoint + 1) % checkpoints.size()
		if current_checkpoint == 0:
			lap_count += 1
			lap_completed.emit()

func add_checkpoint(position: Vector2):
	checkpoints.append(position)
