extends Control

@onready var start_button = $StartButton
@onready var garage_button = $GarageButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	garage_button.pressed.connect(_on_garage_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/DrivingScene.tscn")

func _on_garage_pressed():
	get_tree().change_scene_to_file("res://scenes/GarageScene.tscn")
