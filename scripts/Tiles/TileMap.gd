extends Node2D

enum TileType {
	ROAD_STRAIGHT,
	ROAD_CURVE,
	ROAD_INTERSECTION,
	NATURE,
	MOUNTAIN
}

var grid_size: int = 64
var tiles: Dictionary = {}  # Vector2i -> TileType
var tile_scenes: Dictionary = {}

func _ready():
	# Load tile scenes
	tile_scenes[TileType.ROAD_STRAIGHT] = preload("res://scenes/Tiles/RoadStraight.tscn")
	tile_scenes[TileType.ROAD_CURVE] = preload("res://scenes/Tiles/RoadCurve.tscn")
	tile_scenes[TileType.ROAD_INTERSECTION] = preload("res://scenes/Tiles/RoadIntersection.tscn")
	tile_scenes[TileType.NATURE] = preload("res://scenes/Tiles/Nature.tscn")
	tile_scenes[TileType.MOUNTAIN] = preload("res://scenes/Tiles/Mountain.tscn")
	
	# Create initial road loop
	_create_initial_loop()

func _grid_to_world_iso(grid_pos: Vector2i) -> Vector2:
	# Convert grid coordinates to world position
	# Tiles are isometric diamonds, arranged on regular grid
	var world_x = grid_pos.x * grid_size
	var world_y = grid_pos.y * grid_size
	return Vector2(world_x, world_y)

func _create_initial_loop():
	# Create a simple rectangular loop in isometric grid
	# Using isometric coordinates (diamond pattern)
	var positions = [
		Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0),
		Vector2i(2, 1), Vector2i(2, 2),
		Vector2i(1, 2), Vector2i(0, 2),
		Vector2i(0, 1)
	]
	
	for i in range(positions.size()):
		var pos = positions[i]
		var tile_type = TileType.ROAD_STRAIGHT
		if i == 3 or i == 7:  # Corners
			tile_type = TileType.ROAD_CURVE
		_place_tile(pos, tile_type)

func _place_tile(grid_pos: Vector2i, tile_type: TileType):
	if grid_pos in tiles:
		_remove_tile(grid_pos)
	
	tiles[grid_pos] = tile_type
	var world_pos = _grid_to_world_iso(grid_pos)
	
	if tile_type in tile_scenes:
		var tile_instance = tile_scenes[tile_type].instantiate()
		tile_instance.position = world_pos
		add_child(tile_instance)
		tile_instance.name = "Tile_%d_%d" % [grid_pos.x, grid_pos.y]
	
	# Auto-connect roads
	_auto_connect_roads(grid_pos)

func _auto_connect_roads(grid_pos: Vector2i):
	# Check neighbors and adjust road connections
	var neighbors = [
		Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(0, 1), Vector2i(0, -1)
	]
	
	for neighbor_offset in neighbors:
		var neighbor_pos = grid_pos + neighbor_offset
		if neighbor_pos in tiles:
			_update_tile_connections(grid_pos)
			_update_tile_connections(neighbor_pos)

func _update_tile_connections(grid_pos: Vector2i):
	# Update tile sprite/rotation based on neighbors
	var tile_instance = get_node_or_null("Tile_%d_%d" % [grid_pos.x, grid_pos.y])
	if not tile_instance:
		return
	
	var neighbors = [
		Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(0, 1), Vector2i(0, -1)
	]
	
	var has_neighbor = []
	for offset in neighbors:
		var check_pos = grid_pos + offset
		has_neighbor.append(check_pos in tiles and tiles[check_pos] in [TileType.ROAD_STRAIGHT, TileType.ROAD_CURVE, TileType.ROAD_INTERSECTION])
	
	if tile_instance.has_method("update_connections"):
		tile_instance.update_connections(has_neighbor)

func _remove_tile(grid_pos: Vector2i):
	if grid_pos in tiles:
		var tile_instance = get_node_or_null("Tile_%d_%d" % [grid_pos.x, grid_pos.y])
		if tile_instance:
			tile_instance.queue_free()
		tiles.erase(grid_pos)

func place_tile_at_world_pos(world_pos: Vector2, tile_type: TileType):
	# Convert world position to grid coordinates
	var grid_pos = Vector2i(floor(world_pos.x / grid_size), floor(world_pos.y / grid_size))
	_place_tile(grid_pos, tile_type)
