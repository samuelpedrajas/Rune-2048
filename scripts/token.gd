extends Node2D


var level
var token_to_merge_with = null
var current_pos
var tween


func setup(pos, t):
	level = 0
	tween = t
	current_pos = pos
	_set_content()
	set_pos(_get_world_pos(pos))
	_spawn_animation()


func is_merging():
	return token_to_merge_with


func define_tweening():
	# get the real world position since destination is a position in the matrix
	var world_pos = _get_world_pos(current_pos)

	# interpolate the position
	tween.interpolate_method(
		self, "set_pos", get_pos(), world_pos,
		cfg.ANIMATION_TIME, tween.TRANS_LINEAR, tween.EASE_IN
	)
	# decrease opacity for a smoother animation
	set_opacity(cfg.MOVEMENT_OPACITY)


func update_state():
	set_pos(_get_world_pos(current_pos))
	if get_opacity() < 1:  # must check, otherwise opacity will be set more than once
		set_opacity(1)
	# if it's close enough and flagged as merge -> merge it
	if token_to_merge_with:
		token_to_merge_with.increase_value()
		token_to_merge_with = null
		tween.remove(self, 'set_pos')
		hide()
		queue_free()
		return


func increase_value():
	level += 1
	_set_content()
	# play merge animation
	get_node("animation").play("merge")


func _set_content():
	var token_sprite = get_node("token_sprite")
	var level_label = get_node("token_sprite/level")
	var texture = get_parent().get_token_content(level)
	token_sprite.set_texture(texture)
	level_label.set_text(str(level + 1))


func _spawn_animation():
	# play spawn animation
	get_node("animation").play("spawn")


func _get_world_pos(pos):
	var offset = Vector2(336 / 2, 334 / 2)
	return get_parent().map_to_world(current_pos) + offset
