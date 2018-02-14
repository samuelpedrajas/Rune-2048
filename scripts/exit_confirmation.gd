extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	animation.play("close")
	is_closing = true


func _ready():
	set_pos(cfg.EXIT_WINDOW_POS)
	animation.play("open")


func _on_animation_finished():
	if is_closing:
		queue_free()
