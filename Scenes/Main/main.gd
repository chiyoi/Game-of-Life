extends Node

func _input(event):
	if event.is_action("close"):
		get_tree().quit()
