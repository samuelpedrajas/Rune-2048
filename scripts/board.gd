extends Node2D


func get_token_content(level):
	return cfg.EXCUSES[level - 1]["token_sprite"]


func get_used_cells():
	return get_node("tilemap").get_used_cells()


func map_to_world(pos):
	return get_node("tilemap").map_to_world(pos)
