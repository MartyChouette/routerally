extends Node

signal money_changed(amount: int)
signal tile_unlocked(tile_type: String)

var money: int = 0
var unlocked_tiles: Array[String] = ["road_straight", "road_curve"]
var unlocked_garage_items: Array[String] = []

func add_money(amount: int):
	money += amount
	money_changed.emit(money)
	
func spend_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		money_changed.emit(money)
		return true
	return false

func unlock_tile(tile_type: String):
	if tile_type not in unlocked_tiles:
		unlocked_tiles.append(tile_type)
		tile_unlocked.emit(tile_type)

func unlock_garage_item(item_type: String):
	if item_type not in unlocked_garage_items:
		unlocked_garage_items.append(item_type)
		# Garage items unlock new tiles
		match item_type:
			"nature_unlock":
				unlock_tile("nature")
			"mountain_unlock":
				unlock_tile("mountain")
			"road_advanced":
				unlock_tile("road_intersection")
				unlock_tile("road_chicane")
