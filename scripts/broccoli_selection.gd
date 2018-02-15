extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	animation.play_backwards("open")
	is_closing = true


func _ready():
	animation.play("open")


func _on_animation_finished():
	if is_closing:
		queue_free()
	else:
		for token in get_tree().get_nodes_in_group("token"):
			token.get_node("animation").play("broccoli_selection")
