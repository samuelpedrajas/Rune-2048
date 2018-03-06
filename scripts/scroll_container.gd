extends ScrollContainer


onready var ExcuseEntry = preload("res://scenes/itemlist_entry.tscn")
var tap_start_position
var tap_actual_position
var clicked_excuse = null


func setup():
	# add excuse entries
	var v_box = get_node("vbox_container")
	for i in range(1, cfg.EXCUSES.size() + 1):
		var excuse = cfg.EXCUSES[i - 1]
		var excuse_entry = ExcuseEntry.instance()
		excuse_entry.setup(i, excuse["text"])
		v_box.add_child(excuse_entry)
		if i > g.game.highest_max:
			excuse_entry.set_lock()
		elif i == g.game.current_max:
			excuse_entry.set_actual()

	# add vertical scroll bar
	var v_scroll = VScrollBar.new()
	v_scroll.set_opacity(0)  # weird pixels in lower-left corner otherwise
	v_box.add_child(v_scroll)


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
		var excuse_popup = g.open_popup("excuse_explanation")
		excuse_popup.setup(clicked_excuse)
		clicked_excuse = null


func _can_click():
	var got_the_info = tap_start_position != null and tap_actual_position != null
	if not got_the_info:
		return false

	var input_vector = tap_actual_position - tap_start_position
	if input_vector.length() > cfg.SCROLL_THRESHOLD:
		return false

	return true
