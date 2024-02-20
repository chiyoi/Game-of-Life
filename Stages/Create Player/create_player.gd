extends Node

@export var game_of_life_stage: PackedScene

@onready var background = $Background
@onready var cells = $Node2D/Cells

var game_of_life: Node

func pass_cell_statuses(player_cell_statuses: Array):
	game_of_life = game_of_life_stage.instantiate()
	game_of_life.get_node('Node2D').set('player_cell_statuses', player_cell_statuses)

func start_transition_to_next_stage():
	background.frame = 0
	background.play('Transition')

func next_stage():
	add_sibling(game_of_life)
	queue_free()
