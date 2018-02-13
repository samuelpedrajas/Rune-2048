extends Node

# Directions available for input
const DIRECTIONS = [
	Vector2(1, 0), Vector2(-1, 0),  # Horizontal: -
	Vector2(0, 1), Vector2(0, -1)  # Vertical: |
]

const ANIMATION_TIME = 0.1  # time to travel to the destination, in seconds
const MOVEMENT_OPACITY = 0.2  # opacity when moving

const MOTION_DISTANCE = 15  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.6 # Minimum distance from the direction vectors to make a move

# current available challenges
const CHALLENGES = [
	{
		"goal": 8,
		"board": "res://scenes/levels/1.tscn"
	}
]
const DEFAULT_CHALLENGE = 0
