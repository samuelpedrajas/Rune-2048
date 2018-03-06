extends Node

const DEBUG_MODE = false
const GOAL = 9

# Directions available for input
const DIRECTIONS = [
	Vector2(1, 0), Vector2(-1, 0),  # Horizontal: -
	Vector2(0, 1), Vector2(0, -1)  # Vertical: |
]

const ANIMATION_TIME = 0.10  # time to travel to the destination, in seconds
const MOVEMENT_OPACITY = 0.8  # opacity when moving

const MOTION_DISTANCE = 15  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.6 # Minimum distance from the direction vectors to make a move

const SETTINGS_WINDOW_POS = Vector2(540, 1000)
const BOOK_WINDOW_POS = Vector2(540, 700)
const EXIT_WINDOW_POS = Vector2(540, 850)
const RESET_WINDOW_POS = Vector2(540, 850)
const SCROLL_THRESHOLD = 10

# excuse info
var EXCUSES = [
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/lions.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/lions.png"),
		"text": "Lions eat meat"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/plantshavefeeling.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/plantshavefeeling.png"),
		"text": "Plants have feelings"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/desertedisland.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/desertedisland.png"),
		"text": "Lost in a deserted island"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/ancestors.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/ancestors.png"),
		"text": "We are like cavemen"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/bacon.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/bacon.png"),
		"text": "Mmhh... Bacon"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/canineteeth.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/canineteeth.png"),
		"text": "Look at my canine teeth!"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/onepersonmakesnodifference.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/onepersonmakesnodifference.png"),
		"text": "It's legal to eat meat"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/b12.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/b12.png"),
		"text": "Morality is subjective"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/proteins.png"),
		"book_sprite": ResourceLoader.load("res://images/excuses/proteins.png"),
		"text": "What about proteins?"
	}
]
