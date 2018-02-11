extends Node2D

var level
var token_to_merge_with = null
var current_pos
var tween

signal value_changed

func _ready():
	connect("value_changed", g, "handle_token_increased", [], CONNECT_DEFERRED)

func _set_label():
	var n_digits_old = str(level / 2).length()
	var n_digits_new = str(level).length()
	var label = get_node("token_sprite/value")

	if n_digits_new != n_digits_old:
		label.set_scale(label.get_scale() * cfg.LABEL_SCALE)
		label.set_pos(-label.get_size() * label.get_scale() / 2)
	label.text = str(level)

func _spawn_animation():
	# play spawn animation
	get_node("animation").play("spawn")

func setup(pos, t):
	level = 2
	tween = t
	current_pos = pos
	_set_label()
	set_pos(_get_world_pos(pos))
	_spawn_animation()

func _modulate():
	var sprite = get_node("token_sprite")
	var c = sprite.get_modulate()
	sprite.set_modulate(c.linear_interpolate(cfg.MODULATION_ON_MERGE, cfg.LINEAR_INTERPOLATION_SCALAR))

func _increase_value():
	level *= 2
	emit_signal("value_changed", level)
	_modulate()
	_set_label()
	# play merge animation
	get_node("animation").play("merge")

func _interpolated_move(pos):
	var world_current_pos = _get_world_pos(current_pos)

	# length of the difference between the current position and the destination
	var d = (world_current_pos - pos).length()

	# if it's close enough -> time to restore the opacity
	if d < cfg.MERGE_THRESHOLD:
		if get_opacity() < 1:  # must check, otherwise opacity will be set more than once
			set_opacity(1)
		# if it's close enough and flagged as merge -> merge it
		if token_to_merge_with:
			token_to_merge_with._increase_value()
			token_to_merge_with = null
			tween.remove(self, "_interpolated_move")
			queue_free()
			return

	set_pos(pos)

func _define_tweening():
	# get the real world position since destination is a position in the matrix
	var world_pos = _get_world_pos(current_pos)

	# interpolate the position
	tween.interpolate_method(self, "_interpolated_move", get_pos(), world_pos,
							 cfg.ANIMATION_TIME, tween.TRANS_LINEAR, tween.EASE_IN)
	# decrease opacity for a smoother animation
	set_opacity(cfg.MOVEMENT_OPACITY)

func _get_world_pos(pos):
	var offset = Vector2(336 / 2, 334 / 2)
	return get_parent().map_to_world(current_pos) + offset
