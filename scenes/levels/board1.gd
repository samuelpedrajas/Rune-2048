extends "res://scripts/board.gd"

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
	return TOKEN_SPRITES[level]
