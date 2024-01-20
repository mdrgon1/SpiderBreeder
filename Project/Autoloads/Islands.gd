extends Spatial

var islands_collision_layer := 1

func get_neighbor(island):
	return get_node("../Spatial/StaticBody2")

func calculate_jump_point(from_pos : Vector3, to_island : Spatial) -> Vector3:
	var space := get_world().direct_space_state
	
	var to_pos : Vector3 = space.intersect_ray(
		to_island.global_translation + Vector3.UP * 50.0,
		to_island.global_translation
	)["position"]
	var dir := (to_pos - from_pos).normalized();
	
	# march from_pos to edge of from_island
	var march = to_pos
	for i in range(10):
		var next := space.intersect_ray(
			to_pos - 10.0 * dir + Vector3.UP * 20.0,
			to_pos - 10.0 * dir - Vector3.UP * 20.0
		)
		if next:
			march = next["position"]
			if next["normal"].dot(Vector3.UP) > 0.5:
				to_pos = next["position"]
		else:
			break
	
	return to_pos
