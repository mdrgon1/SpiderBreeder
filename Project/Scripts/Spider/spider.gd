extends RigidBody

onready var anim : AnimationPlayer = $AnimationPlayer
onready var armature : Spatial = $Armature
onready var floor_cast : Spatial = $FloorCast
onready var AI : Node = $AI

export var WEB_SCENE = preload("res://Scenes/Web.tscn")
export var GRAVITY := 80.0
export var SPEED := 20.0

var down := Vector3.DOWN
var rot_snap := 90.0
var vel_snap := 10.0
var flat_vel := Vector3.ZERO
var target_vel := Vector3.ZERO

var auto_movement := true
var anim_override := false
export var climb_enabled := true

var web = null

var current_island = null

func _ready() -> void:
	set_friction(0.0)

func play_animation(name: String) -> void:
	anim.play(name)

func _process(delta : float) -> void:
	
	down = down.normalized()
	flat_vel = Plane(transform.basis.y, 0.0).project(linear_velocity)
	
	if !anim_override:
		if flat_vel.length() > 1.0:
			anim.run()
		else:
			anim.idle()
	
	if web != null:
		web.target = translation
	
	if auto_movement:
		move_towards(target_vel)
	
	if (flat_vel - flat_vel.project(-transform.basis.x)).length() > 0.5:
		var offset = flat_vel.normalized().cross(-transform.basis.x)
		apply_torque_impulse(-offset * rot_snap * delta)
	
	add_central_force(GRAVITY * down)


func move_towards(target : Vector3) -> void:
	target = Plane(transform.basis.y, 0.0).project(target)
	target = target.normalized() * min(target.length(), SPEED)
	add_central_force((target - flat_vel) * vel_snap)


func create_web():
	web = WEB_SCENE.instance()
	if floor_cast.is_colliding():
		web.translation = floor_cast.get_collision_point()
	else:
		web.translation = translation
	get_parent().add_child(web)


func drop_web() -> void:
	if web and floor_cast.is_colliding():
		web.target = floor_cast.get_collision_point()
		web = null


func kill():
	drop_web()
	if web:
		web.queue_free()
	queue_free()


func _integrate_forces(state : PhysicsDirectBodyState) -> void:
	
	if climb_enabled:
		if state.get_contact_count() > 0:
			down = Vector3.ZERO
			for i in state.get_contact_count():
				if state.get_contact_collider_object(i).is_in_group("Climbable"):
					down -= state.get_contact_local_normal(i)
			down = down.normalized()
		if down != Vector3.ZERO and floor_cast.is_colliding():
			down = -floor_cast.get_collision_normal()
	elif down.is_equal_approx(Vector3.ZERO):
		down = Vector3.DOWN
	elif !down.is_equal_approx(Vector3.DOWN):
		down = down.normalized().slerp(Vector3.DOWN, state.step)
	
	if down.cross(-transform.basis.y).length() > 0.05:
		var offset = down.cross(-transform.basis.y)
		var correction_amount = -offset.length() * state.step * rot_snap * 0.2
		var new_basis = state.transform.basis.rotated(offset.normalized(), correction_amount)
		state.transform.basis = new_basis
