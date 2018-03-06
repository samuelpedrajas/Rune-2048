extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	g.save_game()
	animation.play("close")
	is_closing = true


func _ready():
	set_pos(cfg.BOOK_WINDOW_POS)
	animation.play("open")
	get_node("window/scroll_container").setup()


func _on_animation_finished():
	if is_closing:
		queue_free()


func _on_close_button_pressed():
	g.play_audio("click")
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()
