extends Node

@export var conclusion_stage: PackedScene

func conclude(epochs: int, is_converged: bool, is_won: bool):
	var conclusion = conclusion_stage.instantiate()
	if is_converged:
		conclusion.get_node('Control/Details').text = 'You created a stable life. Congratulations.'
	elif is_won:
		conclusion.get_node('Control/Details').text = 'You killed all the enemies. Awesome.'
	else:
		conclusion.get_node('Control/Details').text = 'Your created life stayed over ' + str(epochs) + ' epochs.'
		if epochs > 30:
			conclusion.get_node('Control/Details').text += ' Good job.'
	add_sibling(conclusion)
