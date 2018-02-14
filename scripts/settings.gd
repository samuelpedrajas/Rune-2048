extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	g.save_game()
	animation.play("close")
	is_closing = true


func _ready():
	var music_switch = get_node("window/music_control/switch")
	var sound_switch = get_node("window/sound_control/switch")
	music_switch.set_pressed(not g.music_on)
	sound_switch.set_pressed(not g.sound_on)
	set_pos(cfg.SETTINGS_WINDOW_POS)
	animation.play("open")


func _on_animation_finished():
	if is_closing:
		queue_free()


func _on_switch_sound_toggled(b):
	g.sound_on = not b
	g.play_audio("click")


func _on_switch_music_toggled(b):
	g.music_on = not b
	g.play_audio("click")


func _on_exit_button_pressed():
	g.open_popup("exit_confirmation")


func _on_close_button_pressed():
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()
