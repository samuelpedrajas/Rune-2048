extends Node

var max_current = 0
var current_goal = 0
var current_score = 0 setget _set_current_score

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

func handle_merge(v):
	print("what")
	self.current_score += pow(2, v + 1)
	self.max_current = v if v > max_current else max_current

func win():
	print("Win")
	_next_challenge()

func game_over():
	print("Game over")
	stage.prepare_board(current_challenge.board)

func _set_current_score(v):
	current_score = v
	emit_signal("current_score_changed", current_score)
