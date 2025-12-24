extends Node

signal money_changed(amount: int)
signal tile_unlocked(tile_type: String)
signal time_of_day_changed(time: float)

enum GameState {
	MENU,
	GARAGE,
	DRIVING,
	PAUSED
}

var current_state: GameState = GameState.MENU
var time_of_day: float = 0.5  # 0.0 = midnight, 0.5 = noon, 1.0 = midnight
var light_direction: Vector2 = Vector2(0.5, -0.5).normalized()

func _ready():
	pass

func change_state(new_state: GameState):
	current_state = new_state
	
func set_time_of_day(time: float):
	time_of_day = clamp(time, 0.0, 1.0)
	# Update light direction based on time of day
	var angle = (time_of_day * PI * 2.0) - PI / 2.0
	light_direction = Vector2(cos(angle), sin(angle)).normalized()
	time_of_day_changed.emit(time_of_day)
