extends Node

const GRID_ORIGIN = Vector2i(108, 38)
const GRID_STRIDE = 13
const GRID_SIZE = 8

@export var game_of_life_scene: PackedScene
@export var big_cell_scene: PackedScene

@onready var background = $Background
@onready var node_2D = $Node2D
@onready var cells = $Node2D/Cells
@onready var control = $Control

func _ready():
	for i in GRID_SIZE * GRID_SIZE:
		var pos = index_to_position(i)
		var cell = big_cell_scene.instantiate()
		cell.position = GRID_ORIGIN + pos * GRID_STRIDE
		cells.add_child(cell)

func index_to_position(index: int) -> Vector2i:
	return Vector2i(int(index % GRID_SIZE), int(float(index) / GRID_SIZE))

func _on_start_button_pressed():
	background.frame = 0
	background.play('Transition')
	node_2D.hide()
	control.hide()

func next_stage():
	var player_cell_statuses = []
	for cell in cells.get_children():
		print(cell)
		player_cell_statuses.append(cell.status)
	print(player_cell_statuses)
	var game_of_life = game_of_life_scene.instantiate()
	game_of_life.initiate(player_cell_statuses)
	add_sibling(game_of_life)
	queue_free()
