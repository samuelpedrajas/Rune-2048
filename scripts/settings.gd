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
