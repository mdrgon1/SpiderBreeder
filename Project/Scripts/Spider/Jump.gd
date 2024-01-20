extends Node

onready var anim : AnimationPlayer= $"../AnimationPlayer"

var MIN_JUMP_POWER = 90.0
var target : CollisionObject

export var ready_to_land := false


func _enter() -> void:
	anim.play("jump")
	ready_to_land = false
	owner.target_vel = Vector3.ZERO
	if target:
		owner.target_vel += (target.translation - owner.translation).normalized()
	owner.target_vel *= owner.SPEED
	owner.auto_movement = true

func run(delta: float):
	if ready_to_land:
		for body in owner.get_colliding_bodies():
			if body.is_in_group("Climbable"):
				return "Wander"

func _exit() -> void:
	anim.stop()
	owner.drop_web()
	owner.anim_override = false

func init_jump():
	owner.anim_override = true
	owner.target_vel = Vector3.ZERO
	owner.play_animation("jump")

func jump() -> void:
	owner.auto_movement = false
	if target:
		owner.apply_central_impulse(calc_jump_vec())
		owner.down = Vector3.DOWN
	owner.create_web()

func calc_jump_vec() -> Vector3:
	var target_pos = Islands.calculate_jump_point(owner.global_translation, target)
	var to_target = target_pos - owner.translation
	var straight = to_target
	var up = straight + Vector3.UP * straight.length() * 1.2
	var jump_vec = lerp(straight, up, 0.8)
	var rand_vector = Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized()
	jump_vec = jump_vec.rotated(rand_vector, rand_range(-0.1, 0.1))
	print(jump_vec)
	var jump_power = jump_vec.length()
	if jump_power < MIN_JUMP_POWER:
		jump_vec *= MIN_JUMP_POWER / jump_power
	return jump_vec
