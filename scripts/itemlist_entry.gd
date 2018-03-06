extends Control

onready var grandparent = get_parent().get_parent()
var index = 0


func setup(i, excuse_text):
	index = i
	get_node("text").set_text(excuse_text)


func _on_excuse_pressed():
	grandparent.clicked_excuse = index
