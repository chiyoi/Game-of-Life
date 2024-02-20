extends Node2D

const GRID_ORIGIN = Vector2i(108, 38)
const GRID_STRIDE = 13
const GRID_SIZE = 8

signal player_cell_statuses_submitted(statuses: Array)

@export var big_cell_scene: PackedScene

@onready var cells = $Cells

func _ready():
	for i in GRID_SIZE * GRID_SIZE:
		var pos = index_to_position(i)
		var cell = big_cell_scene.instantiate()
		cell.position = GRID_ORIGIN + pos * GRID_STRIDE
		cells.add_child(cell)

func index_to_position(index: int) -> Vector2i:
	return Vector2i(int(index % GRID_SIZE), int(float(index) / GRID_SIZE))

func _on_start_button_pressed():
	var player_cell_statuses = []
	for cell in cells.get_children():
		player_cell_statuses.append(cell.status)
	emit_signal("player_cell_statuses_submitted", player_cell_statuses)
	queue_free()
