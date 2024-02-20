extends Node2D

# const GRID_ORIGIN = Vector2(88, 18)
# const GRID_STRIDE = 9
const GRID_ORIGIN = Vector2i(108, 38)
const GRID_STRIDE = 13
const GRID_SIZE = 8
# const PLAYER_AREA_START = 4

@export var big_cell_scene: PackedScene

var cells: Array[Node2D]

func _ready():
	cells = []
	cells.resize(GRID_SIZE * GRID_SIZE)
	for i in cells.size():
		var pos = index_to_position(i)
		var cell = big_cell_scene.instantiate()
		cell.position = GRID_ORIGIN + pos * GRID_STRIDE
		add_child(cell)
		cells.append(cell)

func index_to_position(index: int) -> Vector2i:
	return Vector2i(int(index % GRID_SIZE), int(float(index) / GRID_SIZE))

func _on_start_button_pressed():
	queue_free()
