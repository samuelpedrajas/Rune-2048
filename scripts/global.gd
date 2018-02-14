extends Node

# CURRENT WINDOW
var current_window = "main"

# SETTINGS
var music_on = true setget _set_music_on
var music_node
var sound_on = true setget _set_sound_on
var sound_node

var savegame = File.new()

var current_max = 0
var highest_score = 0 setget _set_highest_score
var current_score = 0 setget _set_current_score

var stage

signal highest_score_changed
signal current_score_changed

func _ready():
	stage = get_tree().get_root().get_node("stage")
	music_node = stage.get_node("music")
	sound_node = stage.get_node("samples")
	if not load_game():
		save_game()

func play_audio(sample):
	sound_node.play(sample)

func handle_merge(v):
	self.current_score += pow(2, v + 1)
	self.highest_score = highest_score if highest_score > current_score else current_score
	self.current_max = v if v > current_max else current_max

func save_game():
	savegame.open("user://savegame.save", File.WRITE)
	var game_status = {
		'highest_score': highest_score,
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
	self.highest_score = game_status['highest_score']
	self.music_on = game_status['music_on']
	self.sound_on = game_status['sound_on']
	savegame.close()

func win():
	print("Win")

func game_over():
	print("Game over")

func _set_current_score(v):
	current_score = v
	emit_signal("current_score_changed", current_score)

func _set_highest_score(v):
	highest_score = v
	emit_signal("highest_score_changed", highest_score)

func _set_music_on(v):
	if v:
		music_node.play()
	else:
		music_node.stop()
	music_on = v

func _set_sound_on(v):
	sound_node.set_default_volume(float(v))
	sound_on = v
