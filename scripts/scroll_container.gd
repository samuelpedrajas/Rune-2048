extends ScrollContainer


var tap_start_position
var tap_actual_position
var pressed = false
var clicked_excuse = null


func _input_event(event):
	tap_actual_position = event.pos
	if event.is_action_pressed("click"):
		# if clicked, save the position
		tap_start_position = event.pos
	elif event.is_action_released("click") and _can_click():
		tap_start_position = null
		if clicked_excuse == null:
			clicked_excuse = null
			return
		if clicked_excuse % 2 == 0:
			g.play_audio("merge")
		else:
			g.play_audio("click")
		clicked_excuse = null


func _can_click():
	var got_the_info = tap_start_position != null and tap_actual_position != null
	if not got_the_info:
		return false

	var input_vector = tap_actual_position - tap_start_position
	if input_vector.length() > cfg.SCROLL_THRESHOLD:
		return false

	return true
