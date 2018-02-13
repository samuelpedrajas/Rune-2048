extends Node2D

var music_switch
var sound_switch

func _ready():
	music_switch = get_node("music_control/switch")
	sound_switch = get_node("sound_control/switch")

func setup(music_on, sound_on, pos):
	get_node("music_control/switch").set_pressed(not music_on)
	get_node("sound_control/switch").set_pressed(not sound_on)
	set_pos(pos)
