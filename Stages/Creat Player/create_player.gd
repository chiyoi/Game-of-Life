extends Node

@export var game_of_life_stage: PackedScene

@onready var background = $Background

func start_transition_to_next_stage():
	background.play('Transition')

func next_stage():
	var game_of_life = game_of_life_stage.instantiate()
	add_sibling(game_of_life)
	queue_free()

# DEV: Quick exit.
func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()
# DEV: End
