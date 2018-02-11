extends Node

var matrix = {}

# first positions in each direction line
var direction_pivots = {}
var current_board
var input_handler
var tween

onready var token = preload("res://scenes/token.tscn")

func _ready():
	input_handler = get_node("input_handler")
	input_handler.connect("user_input", self, "move")
	tween = get_node("tween")

func is_valid_pos(p):
	# check if the position is inside the board
	return p in current_board.get_used_cells()

func check_moves_available():
	var used_cells = current_board.get_used_cells()

	if matrix.keys().size() < used_cells.size():
		return true

	for current_cell in used_cells:
		for d in cfg.DIRECTIONS:
			var v = current_cell - d
			if matrix.has(v) and matrix[v].level == matrix[current_cell].level:
				return true
	return false

func _set_direction_pivots():
	# get all used cells in the current board
	var used_cells = current_board.get_used_cells()

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

func _reset_board():
	# remove all tokens from the tween
	tween.remove_all()
	# free current board
	current_board.queue_free()
	# clear direction pivots since they'll be different between boards
	direction_pivots.clear()
	# clear the matrix
	matrix.clear()

func prepare_board(board):
	g.max_current = 0
	g.current_score = 0
	# get the packed scene
	var board_packed_scene = load(board)
	# if we had a previous board, reset it
	if current_board:
		_reset_board()

	current_board = board_packed_scene.instance()  # create a new board
	add_child(current_board)
	_set_direction_pivots()  # set its direction pivots
	_spawn_token()

func _get_empty_position():
	var available_positions = []
	# for each cell used in the board
	for cell in current_board.get_used_cells():
		# if there is no token in it, add it to available positions
		if !matrix.has(cell):
			available_positions.append(cell)

	if available_positions.empty():
		return null

	randomize()  # otherwise it generates the same numbers
	return available_positions[randi() % available_positions.size()]

func _spawn_token():
	var pos = _get_empty_position()
	var t = token.instance()
	current_board.add_child(t)  # t.setup() needs access to the board, so add it before
	t.setup(pos, tween)
	matrix[pos] = t

func _handle_game_status():
	if g.max_current == g.current_goal:
		g.win()
		return
	_spawn_token()
	if not check_moves_available():
		g.game_over()

func move(direction):
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
	elif !is_valid_pos(position):
		line_changes.last_valid_position = position - direction
	else:
		return _move_line(position + direction, direction)

	return line_changes

func _move_token(token, destination):
	if token.current_pos != destination:
		matrix.erase(token.current_pos)  # the token is not in that position anymore
		# update the token position in the matrix if it's not gonna be merged
		# (otherwise we'll override the token that's gonna be increased)
		if !token.token_to_merge_with:
			matrix[destination] = token
	
		token.current_pos = destination  # update the current position
		token._define_tweening()
