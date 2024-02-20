extends AnimatedSprite2D

var status: Status = Status.INACTIVE:
	set(new_status):
		if status == new_status:
			return
		match new_status:
			Status.INACTIVE:
				match status:
					Status.ACTIVE:
						play('Non-Player', -1, true)
					Status.PLAYER:
						play('Player', -1, true)
			Status.ACTIVE:
				match status:
					Status.INACTIVE:
						play('Non-Player')
					Status.PLAYER:
						play('Non-Player', 1, true)
			Status.PLAYER:
				match status:
					Status.INACTIVE:
						play('Player')
					Status.ACTIVE:
						play('Player', 1, true)
		status = new_status

enum Status {
	INACTIVE,
	ACTIVE,
	PLAYER,
}
