extends Node


var TOKEN_SPRITES = [
	ResourceLoader.load("res://images/excuses/lions.png"),
	ResourceLoader.load("res://images/excuses/plantshavefeeling.png"),
	ResourceLoader.load("res://images/excuses/desertedisland.png"),
	ResourceLoader.load("res://images/excuses/ancestors.png"),
	ResourceLoader.load("res://images/excuses/bacon.png"),
	ResourceLoader.load("res://images/excuses/canineteeth.png"),
	ResourceLoader.load("res://images/excuses/onepersonmakesnodifference.png"),
	ResourceLoader.load("res://images/excuses/b12.png"),
	ResourceLoader.load("res://images/excuses/proteins.png")
]


func get_token_content(level):
	return TOKEN_SPRITES[level - 1]


func get_used_cells():
	return get_node("tilemap").get_used_cells()


func map_to_world(pos):
	return get_node("tilemap").map_to_world(pos)
