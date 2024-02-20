extends Label

func _on_node_2d_epoch_updated(epochs: int):
	text = "Epochs: " + str(epochs)
