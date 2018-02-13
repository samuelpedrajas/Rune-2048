extends Node2D

func setup(music_on, sound_on, pos):
	var music_switch = get_node("window/music_control/switch")
	var sound_switch = get_node("window/sound_control/switch")
	music_switch.set_pressed(not music_on)
	sound_switch.set_pressed(not sound_on)
	set_pos(pos)

func close():
	get_tree().set_pause(false)
	queue_free()

func _on_empty_space_pressed():
	close()
