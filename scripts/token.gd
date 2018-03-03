extends Node2D


onready var animation = get_node("animation")
var level
var token_to_merge_with = null
var current_pos
var tween

var is_selectable = false
var is_dying = false


func setup(pos, t, lvl):
	level = lvl
	tween = t
	current_pos = pos
	_set_content()
	set_pos(_get_world_pos(pos))
	animation.play("spawn")


func die():
	is_dying = true
	get_node("broccoli_spawn").set_active(false)
	animation.play_backwards("spawn")


func set_selectable_state():
	is_selectable = true
	animation.play("broccoli_selection")
	get_node("button").show()


func unset_selectable_state():
	is_selectable = false
	animation.stop()
	get_node("broccoli_spawn").set_active(false)
	get_node("glow").hide()
	get_node("button").hide()


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
	# set pos just in case the tweening failed
	set_pos(_get_world_pos(current_pos))
	set_opacity(1)

	# if it's flagged as merge -> merge it
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
	level_label.set_text(str(level))


func _get_world_pos(pos):
	var offset = Vector2(336 / 2, 334 / 2)
	return get_parent().map_to_world(current_pos) + offset


func _on_animation_finished():
	if is_dying:
		queue_free()


func _on_button_pressed():
	print("TOCA")
	if is_selectable and g.game.broccolis > 0:
		g.game.use_broccoli(self)
