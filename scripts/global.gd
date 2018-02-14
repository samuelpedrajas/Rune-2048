extends Node


# CURRENT WINDOW
var current_window = "main"

# SETTINGS
var music_on = true setget _set_music_on
var music_node
var sound_on = true setget _set_sound_on
var sound_node

var savegame = File.new()

var game


func _ready():
	game = get_tree().get_root().get_node("game")
	music_node = game.get_node("music")
	sound_node = game.get_node("samples")
	if not load_game():
		save_game()


func play_audio(sample):
	sound_node.play(sample)


func save_game():
	savegame.open("user://savegame.save", File.WRITE)
	var game_status = {
		'highest_score': game.highest_score,
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
	game.highest_score = game_status['highest_score']
	self.music_on = game_status['music_on']
	self.sound_on = game_status['sound_on']
	savegame.close()


func win():
	print("Win")


func game_over():
	print("Game over")


func _set_music_on(v):
	if v:
		music_node.play()
	else:
		music_node.stop()
	music_on = v


func _set_sound_on(v):
	sound_node.set_default_volume(float(v))
	sound_on = v
