extends Node2D


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

var EXCUSES = [
	"Lions eat meat",
	"Plants have feelings",
	"Lost in a deserted island",
	"We are like cavemen",
	"Mmhh... Bacon",
	"Look at my canine teeth!",
	"It's legal to eat meat",
	"Morality is subjective",
	"What about proteins?"
]


func get_token_content(level):
	return TOKEN_SPRITES[level - 1]


func get_used_cells():
	return get_node("tilemap").get_used_cells()


func map_to_world(pos):
	return get_node("tilemap").map_to_world(pos)
