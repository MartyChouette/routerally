extends Control

@onready var tile_selector = $VBoxContainer/TileSelector
@onready var resume_button = $VBoxContainer/ResumeButton
@onready var place_tile_button = $VBoxContainer/PlaceTileButton

var available_tiles: Array[String] = []
var selected_tile_type: String = "road_straight"

func _ready():
	visible = false
	PlayerData.tile_unlocked.connect(_on_tile_unlocked)
	resume_button.pressed.connect(_on_resume_button_pressed)
	if place_tile_button:
		place_tile_button.pressed.connect(_on_place_tile_button_pressed)
	tile_selector.item_selected.connect(_on_tile_selector_item_selected)
	_update_tile_list()

func _on_tile_unlocked(_tile_type: String):
	_update_tile_list()

func _update_tile_list():
	available_tiles = PlayerData.unlocked_tiles.duplicate()
	tile_selector.clear()
	for tile in available_tiles:
		tile_selector.add_item(tile.replace("_", " ").capitalize())

func _on_resume_button_pressed():
	get_tree().paused = false
	visible = false
	GameManager.change_state(GameManager.GameState.DRIVING)

func _on_tile_selector_item_selected(index: int):
	if index < available_tiles.size():
		selected_tile_type = available_tiles[index]

func _on_place_tile_button_pressed():
	# Get the driving scene and enable tile placement
	var driving_scene = get_tree().get_first_node_in_group("driving_scene")
	if driving_scene:
		driving_scene.tile_placement_mode = true
		driving_scene.selected_tile_type = selected_tile_type
