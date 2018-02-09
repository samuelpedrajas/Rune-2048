extends Node

func _ready():
	pass

func get_used_cells():
	return get_node("tilemap").get_used_cells()

func map_to_world(pos):
	return get_node("tilemap").map_to_world(pos)
