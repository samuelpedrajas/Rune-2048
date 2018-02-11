extends "res://scripts/board.gd"

var TOKEN_SPRITES = [
	ResourceLoader.load("res://images/excuses/desertedisland.png"),
	ResourceLoader.load("res://images/excuses/lions.png"),
	ResourceLoader.load("res://images/excuses/plantshavefeeling.png"),
	ResourceLoader.load("res://images/excuses/ancestors.png"),
	ResourceLoader.load("res://images/excuses/canineteeth.png"),
	ResourceLoader.load("res://images/excuses/circleoflife.png"),
	ResourceLoader.load("res://images/excuses/moralityissubjective.png"),
	ResourceLoader.load("res://images/excuses/lions.png"),
	ResourceLoader.load("res://images/excuses/lions.png")
]

func get_token_content(level):
	return TOKEN_SPRITES[level]
