extends Node2D

var animation
var is_closing = false

func setup(music_on, sound_on, pos):
	var music_switch = get_node("window/music_control/switch")
	var sound_switch = get_node("window/sound_control/switch")
	music_switch.set_pressed(not music_on)
	sound_switch.set_pressed(not sound_on)
	set_pos(pos)
	animation = get_node("animation")
	g.current_window = "settings"

func close():
	animation.play("close")
	is_closing = true

func _on_empty_space_pressed():
	close()

func _on_settings_enter_tree():
	animation.play("open")

func _on_animation_finished():
	if is_closing:
		g.current_window = "main"
		get_tree().set_pause(false)
		queue_free()
