extends Control

@onready var money_label = $VBoxContainer/MoneyLabel
@onready var item_list = $VBoxContainer/ScrollContainer/ItemList

var garage_items = [
	{"name": "Nature Unlock", "cost": 100, "type": "nature_unlock", "description": "Unlock nature tiles"},
	{"name": "Mountain Unlock", "cost": 200, "type": "mountain_unlock", "description": "Unlock mountain tiles"},
	{"name": "Advanced Roads", "cost": 300, "type": "road_advanced", "description": "Unlock intersections and chicanes"},
]

func _ready():
	GameManager.change_state(GameManager.GameState.GARAGE)
	PlayerData.money_changed.connect(_on_money_changed)
	_update_ui()
	_populate_items()

func _update_ui():
	money_label.text = "Money: $%d" % PlayerData.money

func _populate_items():
	item_list.clear()
	for item in garage_items:
		if item.type not in PlayerData.unlocked_garage_items:
			var text = "%s - $%d\n%s" % [item.name, item.cost, item.description]
			item_list.add_item(text)
	item_list.item_selected.connect(_on_item_list_item_selected)

func _on_money_changed(_amount: int):
	_update_ui()

func _on_item_list_item_selected(index: int):
	var item = garage_items[index]
	if PlayerData.spend_money(item.cost):
		PlayerData.unlock_garage_item(item.type)
		_populate_items()

func _on_start_driving_pressed():
	get_tree().change_scene_to_file("res://scenes/DrivingScene.tscn")
