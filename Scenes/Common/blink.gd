extends Label

@export var amplitude = 0.5
@export var frequency = 2.0

var timer: float = 0

func _process(delta):
	timer += delta
	var opacity = amplitude * sin(2.0 * PI * frequency * timer) + 0.5
	self.modulate = Color(1, 1, 1, opacity)
