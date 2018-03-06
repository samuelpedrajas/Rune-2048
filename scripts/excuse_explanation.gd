extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	animation.play("close")
	is_closing = true


func _ready():
	set_pos(cfg.EXCUSE_WINDOW_POS)
	animation.play("open")


func setup(excuse_index):
	var image_node = get_node("window/excuse_image")
	var excuse_sprite = cfg.EXCUSES[excuse_index - 1]["book_sprite"]
	image_node.set_texture(excuse_sprite)


func _on_animation_finished():
	if is_closing:
		queue_free()


func _on_ok_button_pressed():
	g.play_audio("click")
	g.close_popup()


func _on_cancel_button_pressed():
	g.play_audio("click")
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()
