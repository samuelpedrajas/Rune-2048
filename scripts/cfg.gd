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
const BOOK_WINDOW_POS = Vector2(540, 850)
const EXIT_WINDOW_POS = Vector2(540, 850)
const RESET_WINDOW_POS = Vector2(540, 850)
const SCROLL_THRESHOLD = 10