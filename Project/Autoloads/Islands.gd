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

# yuck
func get_island_bounds(s : PackedScene) -> Shape:
	var state := s.get_state()
	var bounds_area_path = null
	for i in range(state.get_node_count()):
		if "IslandBounds" in state.get_node_groups(i):
			bounds_area_path = state.get_node_path(i)
	if(bounds_area_path == null):
		push_error("Scene does not contain Island Bounds node")
		return null
	for i in range(state.get_node_count()):
		if state.get_node_path(i, true) == bounds_area_path:
			for j in range(state.get_node_property_count(i)):
				if(state.get_node_property_name(i, j) == "shape"):
					return state.get_node_property_value(i, j)
	return null

func _process(delta):
	var islands := get_tree().get_nodes_in_group("Island")
	islands.shuffle()
	for island in islands :
		if (
			island.translation.distance_to(Utils.player.translation) < 100.0
			and island.neighbors.size() < 4
			and island.attempt_new_island(load("res://Scenes/Islands/Base.tscn"))
			):
				break
