extends Node

@export var create_player_stage: PackedScene

@onready var background = $Background

func start_transition_to_next_stage(event: InputEvent):
	if (not event is InputEventMouseButton or
			not event.is_pressed() or
			event.button_index != MOUSE_BUTTON_LEFT):
		return
	background.frame = 0
	background.play('Transition')

func next_stage():
	var create_player = create_player_stage.instantiate()
	print(create_player)
	add_sibling(create_player)
	queue_free()
