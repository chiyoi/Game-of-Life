extends Node

const GRID_ORIGIN = Vector2i(88, 18)
const GRID_STRIDE = 9
const GRID_SIZE = 16

@export var create_player_scene: PackedScene
@export var cell_scene: PackedScene

@export var update_interval = 0.2
@export var initial_spawn_rate = 0.4

@onready var background = $Background
@onready var node_2D = $Node2D
@onready var cells = $Node2D/Cells
@onready var control = $Control

var timer = 0

func _ready():
	for i in GRID_SIZE * GRID_SIZE:
		var pos = index_to_position(i)
		var cell = cell_scene.instantiate()
		cell.position = GRID_ORIGIN + pos * GRID_STRIDE
		if randf() < initial_spawn_rate:
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
		var active_neighbours = count_neighbours(pos)
		match active_neighbours:
			2:
				mark[i] = cells.get_child(i).status
			3:
				mark[i] = CellStatus.ACTIVE
			_:
				mark[i] = CellStatus.INACTIVE
	for i in mark.size():
		cells.get_child(i).status = mark[i]

func count_neighbours(pos: Vector2i):
	var active_neighbours = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue
			var neighbour = get_cell(pos + Vector2i(i, j))
			if neighbour:
				match neighbour.status:
					CellStatus.ACTIVE:
						active_neighbours += 1
	return active_neighbours

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
	background.frame = 0
	background.play('Transition')
	node_2D.hide()
	control.hide()

func next_stage():
	var create_player = create_player_scene.instantiate()
	add_sibling(create_player)
	queue_free()

enum CellStatus {
	INACTIVE,
	ACTIVE,
}
