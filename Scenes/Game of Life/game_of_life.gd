extends Node

@export var conclusion_scene: PackedScene
@export var cell_scene: PackedScene

@export var update_interval = 0.2
@export var become_player_threshold = 2
@export var initial_spawn_rate = 0.4

@onready var cells = $Node2D/Cells
@onready var label = $Control/Label

const GRID_ORIGIN = Vector2i(88, 18)
const GRID_STRIDE = 9
const GRID_SIZE = 16
const PLAYER_AREA_MARGIN = 4

var player_cell_statuses: Array

var epochs = 0
var timer = 0
var last_two_marks = [[], []]
var stopped = false

func initiate(_player_cell_statuses: Array):
	player_cell_statuses = _player_cell_statuses

func _ready():
	var move_index = 0
	for i in GRID_SIZE * GRID_SIZE:
		var pos = index_to_position(i)
		var cell = cell_scene.instantiate()
		cell.position = GRID_ORIGIN + pos * GRID_STRIDE
		if (pos.x >= PLAYER_AREA_MARGIN and pos.y >= PLAYER_AREA_MARGIN and
				pos.x < GRID_SIZE - PLAYER_AREA_MARGIN and
				pos.y < GRID_SIZE - PLAYER_AREA_MARGIN):
			cell.status = player_cell_statuses[move_index]
			move_index += 1
		elif randf() < initial_spawn_rate:
			cell.status = CellStatus.ACTIVE
		cells.add_child(cell)

func _process(delta):
	if timer > 0:
		timer -= delta
		return
	timer = update_interval
	var mark: Array[CellStatus] = []
	mark.resize(cells.get_child_count())
	for i in cells.get_child_count():
		var pos = index_to_position(i)
		var neighbours = count_neighbours(pos)
		var active_neighbours = neighbours[0]
		var player_neighbours = neighbours[1]
		match active_neighbours:
			2:
				mark[i] = cells.get_child(i).status
			3:
				if player_neighbours >= become_player_threshold:
					mark[i] = CellStatus.PLAYER
				else:
					mark[i] = CellStatus.ACTIVE
			_:
				mark[i] = CellStatus.INACTIVE
	var player_count = 0
	var non_player_count = 0
	for i in mark.size():
		if mark[i] == CellStatus.PLAYER:
			player_count += 1
		elif mark[i] == CellStatus.ACTIVE:
			non_player_count += 1
		cells.get_child(i).status = mark[i]
	if not stopped:
		if player_count == 0:
			stopped = true
			show_conclusion(false, false)
		elif (mark.hash() == last_two_marks[0].hash() or
			mark.hash() == last_two_marks[1].hash()):
			stopped = true
			show_conclusion(true, false)
		elif non_player_count == 0:
			stopped = true
			show_conclusion(false, true)
		last_two_marks[epochs % 2] = mark
		epochs += 1
	update_label()

func count_neighbours(pos: Vector2):
	var active_neighbours = 0
	var player_neighbours = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue
			var neighbour = get_cell(pos + Vector2(i, j))
			if neighbour:
				match neighbour.status:
					CellStatus.ACTIVE:
						active_neighbours += 1
					CellStatus.PLAYER:
						active_neighbours += 1
						player_neighbours += 1
	return [active_neighbours, player_neighbours]

func index_to_position(index: int) -> Vector2i:
	return Vector2i(int(index % GRID_SIZE), int(float(index) / GRID_SIZE))

func get_cell(pos: Vector2) -> Node:
	return cells.get_child(position_to_index(pos))

func position_to_index(pos: Vector2i) -> int:
	return roll_offset(pos.y) * GRID_SIZE + roll_offset(pos.x)

func roll_offset(x: int):
	return (x + GRID_SIZE) % GRID_SIZE

func _on_control_gui_input(event: InputEvent):
	if (not event is InputEventMouseButton or
			not event.is_pressed() or
		event.button_index != MOUSE_BUTTON_LEFT):
		return
	queue_free()

func show_conclusion(is_converged: bool, is_won: bool):
	var conclusion = conclusion_scene.instantiate()
	if is_converged:
		conclusion.get_node('Control/Title').text = 'Converged'
		conclusion.get_node('Control/Details').text = 'You created a stable life. Congratulations.'
	elif is_won:
		conclusion.get_node('Control/Title').text = 'Win'
		conclusion.get_node('Control/Details').text = 'You killed all the enemies. Awesome.'
	else:
		conclusion.get_node('Control/Title').text = 'Game Over'
		conclusion.get_node('Control/Details').text = 'Your created life struggled over ' + str(epochs) + ' epochs.'
		if epochs > 30:
			conclusion.get_node('Control/Details').text += ' Good job.'
	add_sibling(conclusion)

func update_label():
	label.text = "Epochs: " + str(epochs)

enum CellStatus {
	INACTIVE,
	ACTIVE,
	PLAYER,
}
