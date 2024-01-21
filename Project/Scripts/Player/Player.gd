extends KinematicBody

class_name Player

const SPIDER_SCENE = preload("res://Scenes/spider.tscn")

onready var camera : Camera = $Camera
onready var view_ray : RayCast = $Camera/RayCast

func _input(e : InputEvent):
	if e.is_action_pressed("breed"):
		var c := view_ray.get_collider()
		if c and c.is_in_group("Spider"):
			breed_spider()
	if e.is_action_pressed("eat"):
		var c := view_ray.get_collider()
		if c and c.is_in_group("Spider"):
			eat_spider(c)

func breed_spider():
	var spider : CollisionObject = SPIDER_SCENE.instance()
	var spider_collider_shape = spider.shape_owner_get_shape(0, 0)
	
	var space_state := get_world().direct_space_state
	var q := PhysicsShapeQueryParameters.new()
	q.exclude = [self]
	q.set_shape(spider_collider_shape)
	q.transform = view_ray.global_transform
	var motion := view_ray.cast_to
	motion = view_ray.global_transform.basis.get_rotation_quat() * motion
	var dist : float = space_state.cast_motion(q, motion)[0]
	
	spider.translation = view_ray.global_transform.origin + motion * dist
	get_tree().root.add_child(spider)
	
func eat_spider(c : Node):
	c.queue_free()
