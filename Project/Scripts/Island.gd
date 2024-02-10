extends Spatial

class_name Island

onready var bounds : Area = $Bounds

var neighbors = []

func add_neighbor(i : Island) -> void:
	if i != self and not(i in neighbors):
		neighbors.append(i)
		i.add_neighbor(self)

func remove_neighbor(i : Island) -> void:
	if i in neighbors:
		neighbors.erase(i)
		i.remove_neighbor(self)

func island_bound_query() -> PhysicsShapeQueryParameters:
	var q := PhysicsShapeQueryParameters.new()
	q.collide_with_bodies = false
	q.collide_with_areas = true
	q.transform = global_transform
	return q

func _ready():
	var space_state := get_world().direct_space_state
	var q := island_bound_query()
	var shape = bounds.shape_owner_get_shape(0, 0).duplicate()
	if shape is SphereShape:
		shape.radius *= 1.5
	else:
		printerr("NEED A CASE")
	q.set_shape(shape)
	var res = space_state.intersect_shape(q)
	for c in res:
		if(c.collider.owner is get_script()):
			add_neighbor(c.collider.get_parent())

func _exit_tree():
	for n in neighbors:
		remove_neighbor(n)

func attempt_new_island(i : PackedScene) -> bool:
	var to_neighbors := PoolVector3Array()
	to_neighbors.resize(neighbors.size())
	
	for i in range(neighbors.size()):
		to_neighbors[i] = neighbors[i].translation - translation
	
	var vec := Utils.random_vec().normalized()
	if translation.y <= 30.0:
		vec.y = abs(vec.y)
	vec.y *= 0.15;
	vec = vec.normalized()
	print({
		"translation": translation,
		"vec": vec
	})
	
	for i in range(3):
		var x := Vector3.ZERO
		for n in to_neighbors:
			x += vec - n
		vec += 0.5 * x.normalized()
		vec = vec.normalized()
	
	var space_state := get_world().direct_space_state
	var q := island_bound_query()
	for island in get_tree().get_nodes_in_group("IslandBounds"):
		if(island.owner != self):
			q.exclude.append(island)
	q.transform = global_transform.translated(vec * 1000.0)
	var bounds = Islands.get_island_bounds(i)
	q.set_shape(bounds)
	var yuh = space_state.cast_motion(q, -vec * 1000.0)
	var dist : float = yuh[0]
	
	if dist == 0.0:
		return false
	
	var new_pos = translation + vec * 1000.0 * (1.0 - dist)
	if new_pos.y < 50.0:
		return false
	
	var new_island : Island = i.instance()
	new_island.translation = new_pos
	get_parent().add_child(new_island)
	add_neighbor(new_island)
	
	return true
