extends Node

var max_current = 0 setget _set_max_current
var current_goal = 0 setget _set_current_goal
var current_score = 0

var stage
var current_challenge
var next_challenge_index

signal current_max_changed
signal current_goal_changed
signal current_score_changed
signal new_challenge

func _ready():
	stage = get_tree().get_root().get_node("stage")
	next_challenge_index = cfg.DEFAULT_CHALLENGE
	call_deferred("_next_challenge")

func _next_challenge():
	current_challenge = cfg.CHALLENGES[next_challenge_index]
	self.current_goal = current_challenge.goal
	next_challenge_index += 1
	stage.prepare_board(current_challenge.board)

func _check_win():
	if max_current == current_goal:
		print("WIN")
		self.max_current = 0
		_next_challenge()

func handle_token_increased(v):
	self.max_current = v if v > max_current else max_current
	_set_current_score(v)
	_check_win()

func game_over():
	print("Game over")
	self.max_current = 0
	stage.prepare_board(current_challenge.board)

func _set_max_current(v):
	max_current = v
	emit_signal("current_max_changed", max_current)

func _set_current_goal(v):
	current_goal = v
	emit_signal("current_goal_changed", current_goal)

func _set_current_score(level):
	current_score += pow(2, level + 1)
	emit_signal("current_score_changed", current_score)
