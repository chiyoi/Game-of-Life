extends AnimatedSprite2D

var status: Status = Status.INACTIVE:
	set(new_status):
		if status == new_status:
			return
		match new_status:
			Status.INACTIVE:
				play('Player', -1, true)
			Status.ACTIVE:
				play('Player')
		status = new_status

var hold = false

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.is_released():
		hold = false
		return
	if not event is InputEventMouse or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	if hold:
		return
	hold = true
	match status:
		Status.INACTIVE:
			status = Status.ACTIVE
		Status.ACTIVE:
			status = Status.INACTIVE

enum Status {
	INACTIVE,
	ACTIVE,
}

func _on_area_2d_mouse_exited():
	hold = false
