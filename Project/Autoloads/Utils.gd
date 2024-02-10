extends Spatial

var player : Player

func random_vec() -> Vector3:
	return Vector3(
		rand_range(-1, 1),
		rand_range(-1, 1),
		rand_range(-1, 1)
	)
