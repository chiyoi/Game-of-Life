extends Node

# const GRID_ORIGIN = Vector2(88, 18)
# const GRID_STRIDE = 9
# const CREATE_PLAYER_GRID_ORIGIN = Vector2(108, 38)
# const CREATE_PLAYER_GRID_STRIDE = 13
# const TRANSITION_STRIDE = 8
# const GRID_SIZE = 16
# const PLAYER_GRID_SIZE = 8
# const PLAYER_AREA_START = 4

@export var create_player_stage: PackedScene

# @export var cell_scene: PackedScene
# @export var big_cell_scene: PackedScene
# @export var create_player_control_scene: PackedScene
# @export var game_of_life_control_scene: PackedScene
# @export var grids_scene: PackedScene
# @export var big_grids_scene: PackedScene

# @export var update_interval: float
# @export var become_player_threshold: int
# @export var initial_spawn_rate: float

@onready var background = $Background

# #region States
# var cells: Array[Node]
# var stage: Stage = Stage.INTRODUCTION
# var timer = 0
# #endregion

func start_transition_to_next_stage(event: InputEvent):
	if (not event is InputEventMouseButton or
			not event.is_pressed() or
			event.button_index != MOUSE_BUTTON_LEFT):
		return
	background.play('Transition')

func next_stage():
	var create_player = create_player_stage.instantiate()
	add_sibling(create_player)
	queue_free()

# func initiate_create_player():
# 	stage = Stage.CREATE_PLAYER
# 	var grids = big_grids_scene.instantiate()
# 	add_child(grids)
# 	var control = create_player_control_scene.instantiate()
# 	var start_button = control.get_node('StartButton')
# 	start_button.connect('pressed', func():
# 		grids.queue_free()
# 		control.queue_free())
# 	start_button.connect('pressed', transition_from_create_player_to_game_of_life, CONNECT_ONE_SHOT)
# 	add_child(control)
# 	cells = []
# 	cells.resize(constants.PLAYER_GRID_SIZE * constants.PLAYER_GRID_SIZE)
# 	for i in cells.size():
# 		var pos = index_to_position(i)
# 		var cell = big_cell_scene.instantiate()
# 		cell.position = constants.CREATE_PLAYER_GRID_ORIGIN + pos * constants.CREATE_PLAYER_GRID_STRIDE
# 		add_child(cell)
# 		cells.append(cell)

# func transition_from_create_player_to_game_of_life():
# 	var player_cell_statuses: Array[CellStatus] = []
# 	for cell in cells:
# 		player_cell_statuses.append(cell.status)
# 		cell.queue_free()
# 	background.play('Transition')
# 	background.connect('animation_finished', func():
# 		initiate_game_of_life(player_cell_statuses))

# func initiate_game_of_life(player_cell_statuses: Array[CellStatus]):
# 	stage = Stage.GAME_OF_LIFE
# 	var move_index = 0
# 	var grids = grids_scene.instantiate()
# 	add_child(grids)
# 	cells = []
# 	cells.resize(constants.GRID_SIZE * constants.GRID_SIZE)
# 	for i in cells.size():
# 		var pos = index_to_position(i)
# 		var cell = cell_scene.instantiate()
# 		cell.position = constants.GRID_ORIGIN + pos * constants.GRID_STRIDE
# 		cells[i] = cell
# 		if (pos.x >= constants.PLAYER_AREA_START and
# 				pos.y >= constants.PLAYER_AREA_START and
# 				pos.x < constants.GRID_SIZE - constants.PLAYER_AREA_START and
# 				pos.y < constants.GRID_SIZE - constants.PLAYER_AREA_START):
# 			cell.status = player_cell_statuses[move_index]
# 			move_index += 1
# 		elif randf() < initial_spawn_rate:
# 			cell.status = CellStatus.NON_PLAYER
# 		add_child(cell)

# func _process(delta):
# 	if stage != Stage.GAME_OF_LIFE:
# 		return
# 	if timer > 0:
# 		timer -= delta
# 		return
# 	timer = update_interval
# 	var mark: Array[CellStatus] = []
# 	mark.resize(cells.size())
# 	var player_count = 0
# 	for i in cells.size():
# 		var pos = index_to_position(i)
# 		var neighbours = count_neighbours(pos)
# 		var active_neighbours = neighbours[0]
# 		var player_neighbours = neighbours[1]
# 		match active_neighbours:
# 			2:
# 				mark[i] = cells[i].status
# 			3:
# 				if player_neighbours >= become_player_threshold:
# 					mark[i] = CellStatus.PLAYER
# 				else:
# 					mark[i] = CellStatus.NON_PLAYER
# 			_:
# 				mark[i] = CellStatus.INACTIVE
# 	if player_count == 0:
# 		conclusion()

# func conclusion(converged: bool = false):
# 	stage = Stage.CONCLUSION

# #region Helpers
# func count_neighbours(pos: Vector2):
# 	var active_neighbours = 0
# 	var player_neighbours = 0
# 	for i in range(-1, 2):
# 		for j in range(-1, 2):
# 			if i == 0 and j == 0:
# 				continue
# 			var neighbour = get_cell(pos + Vector2(i, j))
# 			if neighbour:
# 				match neighbour.status:
# 					CellStatus.NON_PLAYER:
# 						active_neighbours += 1
# 					CellStatus.PLAYER:
# 						active_neighbours += 1
# 						player_neighbours += 1
# 	return [active_neighbours, player_neighbours]

# func get_cell(pos: Vector2) -> Node:
# 	return cells[position_to_index(pos)]

# func index_to_position(index: int) -> Vector2:
# 	return Vector2(index % GRID_SIZE, float(index) / GRID_SIZE)

# func position_to_index(pos: Vector2) -> int:
# 	return roll_offset(int(pos.y)) * GRID_SIZE + roll_offset(int(pos.x))

# func roll_offset(x: int):
# 	return (x + GRID_SIZE) % GRID_SIZE

# enum Stage {
# 	INTRODUCTION,
# 	CREATE_PLAYER,
# 	GAME_OF_LIFE,
# 	CONCLUSION,
# }

# enum CellStatus {
# 	INACTIVE,
# 	NON_PLAYER,
# 	PLAYER,
# }
# #endregion

# DEV: Quick exit.
func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()
# DEV: End
