extends Node

func _on_control_gui_input(event: InputEvent):
	if (not event is InputEventMouseButton or
			not event.is_pressed() or
			event.button_index != MOUSE_BUTTON_LEFT):
		return
	get_tree().quit()
