extends Node2D

var level
var token_to_merge_with = null
var current_pos
var tween

func _set_content():
	var content = get_node("token_sprite/content")
	var texture = get_parent().get_token_content(level)
	content.set_texture(texture)

func _spawn_animation():
	# play spawn animation
	get_node("animation").play("spawn")

func setup(pos, t):
	level = 0
	tween = t
	current_pos = pos
	_set_content()
	set_pos(_get_world_pos(pos))
	_spawn_animation()

func _modulate():
	var sprite = get_node("token_sprite")
	var c = sprite.get_modulate()
	sprite.set_modulate(c.linear_interpolate(cfg.MODULATION_ON_MERGE, cfg.LINEAR_INTERPOLATION_SCALAR))

func _increase_value():
	level += 1
	g.handle_merge(level)
	_modulate()
	_set_content()
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
