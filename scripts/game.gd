extends Node

# game scores
var current_max = 1
var highest_score = 0 setget _set_highest_score
var current_score = 0 setget _set_current_score

# items
var broccolis = 2

# keep board state
var matrix = {}

# child nodes
var board
var input_handler
var tween

# first positions in each direction line
var direction_pivots = {}

# signals
signal highest_score_changed
signal current_score_changed

# for instancing tokens
onready var token = preload("res://scenes/token.tscn")
onready var broccoli = preload("res://scenes/broccoli_selection.tscn")


func use_broccoli(token):
	if broccolis > 0:
		broccolis -= 1
		matrix.erase(token.current_pos)
		token.die()

	if broccolis == 0 and g.current_event:
		print("no more broccolis")
		g.stop_event()

	if matrix.empty():
		var t = _spawn_token()
		t.set_selectable_state()
		t.get_node("broccoli_spawn").set_active(true)


func start_broccoli_selection():
	var scene = broccoli.instance()
	get_node("event_layer").add_child(scene)
	return scene


func restart_game():
	# here the screen is already black
	self.current_score = 0
	current_max = 1
	# remove all tokens from the tween
	tween.remove_all()
	# clear the matrix
	matrix.clear()
	# remove all tokens one by one
	for token in get_tree().get_nodes_in_group("token"):
		token.hide()
		token.queue_free()
	_spawn_token()
	input_handler.blocked = false


func _ready():
	# get some child nodes
	input_handler = get_node("input_handler")
	tween = get_node("tween")
	board = get_node("board_layer/board")

	# the input handler will parse the input and send it to move function
	input_handler.connect("user_input", self, "_move")

	# only needed once
	_set_direction_pivots()

	_spawn_token()
	input_handler.blocked = false


func _set_direction_pivots():
	# get all used cells in the current board
	var used_cells = board.get_used_cells()

	# for each used cell, if it has no previous cell but it has a next one
	# for a given direction, then it is a pivot for that direction
	for cell_pos in used_cells:
		for direction in cfg.DIRECTIONS:
			var next_pos = (cell_pos + direction)
			var prev_pos = (cell_pos - direction)
			if next_pos in used_cells and !(prev_pos in used_cells):
				if !direction_pivots.has(direction):
					direction_pivots[direction] = []
				direction_pivots[direction].append(cell_pos)


### WIN / LOSE ###

func win():
	print("Win")
	g.transition.restart_game()


func game_over():
	print("Game over")
	g.transition.restart_game()


### GAME MECHANICS ###

func _move(direction):
	# information about the events in the board
	var board_changed = {
		"movement": false,  # did the tokens moved?
		"merge": false  # did any token merged with another one?
	}

	# for each pivot in this direction
	for pivot in direction_pivots[direction]:
		var line_changes = _move_line(pivot, direction)
		# update board information
		board_changed.movement = board_changed.movement or line_changes.movement
		board_changed.merge = board_changed.merge or line_changes.merge

	if board_changed.merge:
		# play merge sound if there was at least one merge in the board
		get_node("samples").play("merge")

	if board_changed.movement:
		input_handler.blocked = true
		tween.start()
		# When the animation of all tokens is finished -> prepare next round
		tween.interpolate_callback(self, tween.get_runtime(), "_handle_game_status")


func _move_line(position, direction):
	var line_changes = {
		"movement": false,
		"merge": false,
		"last_token": null,
		"last_valid_position": null
	}

	# 3 cases: current position has a token, current position is not valid and current position is
	# valid but it doesn't have a token
	if matrix.has(position):
		var current_token = matrix[position]
		var changes = _move_line(position + direction, direction)
		var last_token = changes.last_token
		var token_destination = changes.last_valid_position

		# conditions for positioning and merging
		if last_token and (last_token.token_to_merge_with or last_token.level != current_token.level):
			token_destination -= direction
		elif last_token and !last_token.token_to_merge_with and last_token.level == current_token.level:
			line_changes.merge = true
			current_token.token_to_merge_with = last_token

		# move current token after moving the ones after it
		_move_token(current_token, token_destination)

		# update line_changes information for the previous position in the recursion
		line_changes.movement = position != token_destination
		line_changes.merge = line_changes.merge or changes.merge
		line_changes.last_token = current_token
		line_changes.last_valid_position = token_destination
	elif !_is_valid_pos(position):
		line_changes.last_valid_position = position - direction
	else:
		return _move_line(position + direction, direction)

	return line_changes


func _move_token(token, destination):
	if token.current_pos != destination:
		matrix.erase(token.current_pos)  # the token is not in that position anymore
		# update the token position in the matrix if it's not gonna be merged
		# (otherwise we'd override the token that's gonna be increased)
		if !token.token_to_merge_with:
			matrix[destination] = token
	
		token.current_pos = destination  # update the current position
		token.define_tweening()


func _is_valid_pos(p):
	# check if the position is inside the board
	return p in board.get_used_cells()


func _handle_game_status():
	# update score and update token state
	for token in get_tree().get_nodes_in_group("token"):
		if token.is_merging():
			# manage scores
			var achieved_level = token.level + 1
			self.current_score += pow(2, achieved_level)
			self.highest_score = highest_score if highest_score > current_score else current_score
			self.current_max = achieved_level if achieved_level > current_max else current_max
		token.update_state()

	g.save_game()

	# have you won?
	if current_max == cfg.GOAL:
		win()
	else:
		_spawn_token()
		if not _check_moves_available():
			game_over()
		input_handler.blocked = false


func _spawn_token():
	var pos = _get_empty_position()
	if pos == null:
		return

	var t = token.instance()
	board.add_child(t)  # t.setup() needs access to the board, so add it before
	t.setup(pos, tween)
	matrix[pos] = t

	return t


func _get_empty_position():
	var available_positions = []

	# for each cell used in the board
	for cell in board.get_used_cells():
		# if there is no token in it, add it to available positions
		if !matrix.has(cell):
			available_positions.append(cell)

	if available_positions.empty():
		return null

	randomize()  # otherwise it generates the same numbers
	return available_positions[randi() % available_positions.size()]


func _check_moves_available():
	var used_cells = board.get_used_cells()

	if matrix.keys().size() < used_cells.size():
		return true

	for current_cell in used_cells:
		for d in cfg.DIRECTIONS:
			var v = current_cell - d
			if matrix.has(v) and matrix[v].level == matrix[current_cell].level:
				return true
	return false


func _set_current_score(v):
	current_score = v
	emit_signal("current_score_changed", current_score)


func _set_highest_score(v):
	highest_score = v
	emit_signal("highest_score_changed", highest_score)
