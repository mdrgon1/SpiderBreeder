extends Spatial

var children := []

func _ready() -> void:
	for child in get_children():
		if child is RayCast:
			children.append(child)

func is_colliding() -> bool:
	for child in children:
		if child.is_colliding():
			return true
	return false

func get_collision_normal() -> Vector3:
	var norm := Vector3.ZERO
	for child in children:
		if child.is_colliding():
			norm += child.get_collision_normal()
	return norm.normalized()

func get_collision_point() -> Vector3:
	var point := Vector3.ZERO
	var i := 0
	for child in children:
		if child.is_colliding():
			point += child.get_collision_point()
			i += 1
	return point / i
