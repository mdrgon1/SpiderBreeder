extends Spatial

onready var mesh : Spatial = $Mesh
onready var collision_shape = $StaticBody/CollisionPolygon

onready var collision_polygon_orig = PoolVector2Array(collision_shape.polygon)

var target = Vector3.ZERO setget set_target

func set_target(value):
	target = value
	look_at(target, Vector3.UP)
	
	var length = (target - translation).length()
	var height = pow(length, 0.5) + 1.0
	mesh.scale.x = length
	mesh.scale.y = height
	
	for i in range(len(collision_polygon_orig)):
		var point = collision_polygon_orig[i]
		point.x *= length
		point.y *= height
		collision_shape.polygon[i] = point
