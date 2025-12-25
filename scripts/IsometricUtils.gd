extends Node

# Isometric utility functions
# Standard isometric angle: 30 degrees (2:1 ratio)

static func world_to_isometric(world_pos: Vector2) -> Vector2:
	# Convert world coordinates to isometric screen coordinates
	var iso_x = (world_pos.x - world_pos.y)
	var iso_y = (world_pos.x + world_pos.y) / 2.0
	return Vector2(iso_x, iso_y)

static func isometric_to_world(iso_pos: Vector2) -> Vector2:
	# Convert isometric screen coordinates to world coordinates
	var world_x = (iso_pos.x / 2.0) + iso_pos.y
	var world_y = iso_pos.y - (iso_pos.x / 2.0)
	return Vector2(world_x, world_y)

static func grid_to_world(grid_pos: Vector2i, tile_size: float = 64.0) -> Vector2:
	# Convert grid coordinates to isometric world position
	var world_x = grid_pos.x * tile_size
	var world_y = grid_pos.y * tile_size
	return world_to_isometric(Vector2(world_x, world_y))

static func world_to_grid(world_pos: Vector2, tile_size: float = 64.0) -> Vector2i:
	# Convert world position to grid coordinates
	var iso_world = isometric_to_world(world_pos)
	return Vector2i(floor(iso_world.x / tile_size), floor(iso_world.y / tile_size))
