extends Node2D

@export var tile_type: String = "road_straight"
@onready var sprite = $Sprite2D
@onready var normal_map_sprite = get_node_or_null("NormalMap")

var connections: Array[bool] = [false, false, false, false]  # Right, Left, Down, Up

func _ready():
	_setup_normal_map_shader()
	_update_visuals()

func _setup_normal_map_shader():
	# Apply shader material for normal map lighting
	if sprite:
		var shader_material = ShaderMaterial.new()
		var shader = load("res://shaders/normal_map_lighting.gdshader")
		if shader:
			shader_material.shader = shader
			sprite.material = shader_material
			# Set normal map texture if available
			if normal_map_sprite and normal_map_sprite.texture:
				shader_material.set_shader_parameter("normal_texture", normal_map_sprite.texture)
			_update_shader_parameters()

func _update_shader_parameters():
	if sprite and sprite.material and sprite.material is ShaderMaterial:
		var mat = sprite.material as ShaderMaterial
		mat.set_shader_parameter("time_of_day", GameManager.time_of_day)
		mat.set_shader_parameter("light_direction", GameManager.light_direction)
		mat.set_shader_parameter("light_intensity", 1.0)

func _process(_delta):
	_update_shader_parameters()

func update_connections(neighbor_array: Array[bool]):
	connections = neighbor_array
	_update_visuals()

func _update_visuals():
	# Update sprite rotation and appearance based on connections
	# Count connections
	var connection_count = 0
	for conn in connections:
		if conn:
			connection_count += 1
	
	# Rotate based on connections
	if connection_count == 2:
		# Determine rotation based on which sides are connected
		if connections[0] and connections[1]:  # Right and Left
			rotation = 0.0
		elif connections[2] and connections[3]:  # Down and Up
			rotation = PI / 2.0
		elif connections[0] and connections[2]:  # Right and Down
			rotation = PI / 4.0
		elif connections[0] and connections[3]:  # Right and Up
			rotation = -PI / 4.0
		elif connections[1] and connections[2]:  # Left and Down
			rotation = 3 * PI / 4.0
		elif connections[1] and connections[3]:  # Left and Up
			rotation = -3 * PI / 4.0
