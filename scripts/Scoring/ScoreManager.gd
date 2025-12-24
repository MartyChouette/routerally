extends Node

func _ready():
	add_to_group("score_manager")

signal score_event(event_type: String, value: int)

enum ScoreEvent {
	DRIFT,
	LAP_COMPLETE,
	NEAR_MISS,
	PASS,
	LAP_OTHER
}

func award_drift(distance: float):
	var amount = int(distance / 100.0)
	PlayerData.add_money(amount)
	score_event.emit("drift", amount)

func award_lap():
	var amount = 50
	PlayerData.add_money(amount)
	score_event.emit("lap", amount)

func award_near_miss():
	var amount = 25
	PlayerData.add_money(amount)
	score_event.emit("near_miss", amount)

func award_pass():
	var amount = 30
	PlayerData.add_money(amount)
	score_event.emit("pass", amount)

func award_lap_other():
	var amount = 100
	PlayerData.add_money(amount)
	score_event.emit("lap_other", amount)
