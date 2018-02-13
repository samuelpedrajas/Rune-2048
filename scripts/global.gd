extends Node

# CURRENT WINDOW
var current_window = "main"

# SETTINGS
var music_on = true setget _set_music_on
var music_node
var sound_on = true setget _set_sound_on
var sound_node

var savegame = File.new()

var max_current = 0
var max_score = 0 setget _set_max_score
var current_goal = 0
var current_score = 0 setget _set_current_score

var stage
var current_challenge
var next_challenge_index

signal current_max_changed
signal max_score_changed
signal current_goal_changed
signal current_score_changed
signal new_challenge

func _ready():
	stage = get_tree().get_root().get_node("stage")
	music_node = stage.get_node("music")
	sound_node = stage.get_node("samples")
	next_challenge_index = cfg.DEFAULT_CHALLENGE
	call_deferred("_next_challenge")
	if not load_game():
		save_game()

func _next_challenge():
	current_challenge = cfg.CHALLENGES[next_challenge_index]
	self.current_goal = current_challenge.goal
	next_challenge_index += 1
	stage.prepare_board(current_challenge.board)

func handle_merge(v):
	self.current_score += pow(2, v + 1)
	self.max_score = max_score if max_score > current_score else current_score
	self.max_current = v if v > max_current else max_current

func save_game():
	savegame.open("user://savegame.save", File.WRITE)
	var game_status = {
		'max_score': max_score,
		'music_on': music_on,
		'sound_on': sound_on
	}
	savegame.store_line(game_status.to_json())
	savegame.close()

func load_game():
	if !savegame.file_exists("user://savegame.save"):
		return false

	var game_status = {}
	savegame.open("user://savegame.save", File.READ)
	game_status.parse_json(savegame.get_line())
	self.max_score = game_status['max_score']
	self.music_on = game_status['music_on']
	self.sound_on = game_status['sound_on']
	savegame.close()

func win():
	print("Win")
	_next_challenge()

func game_over():
	print("Game over")
	stage.prepare_board(current_challenge.board)

func _set_current_score(v):
	current_score = v
	emit_signal("current_score_changed", current_score)

func _set_max_score(v):
	max_score = v
	emit_signal("max_score_changed", max_score)

func _set_music_on(v):
	if v:
		music_node.play()
	else:
		music_node.stop()
	music_on = v

func _set_sound_on(v):
	sound_node.set_default_volume(float(v))
	sound_on = v
