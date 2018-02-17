extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	animation.play_backwards("open")
	is_closing = true


func _ready():
	var n = g.game.get_node("event_layer").get_layer()
	animation.play("open")
	g.game.get_node("board_layer").set_layer(n + 1)


func _on_animation_finished():
	if is_closing:
		for token in get_tree().get_nodes_in_group("token"):
			token.unset_selectable_state()
		g.game.get_node("board_layer").set_layer(0)
		queue_free()
	else:
		for token in get_tree().get_nodes_in_group("token"):
			token.set_selectable_state()


func _on_clickabe_area_pressed():
	g.stop_event()
