extends Node

var target_jump_from = Vector3.ZERO
var target_island = null

func _enter():
	owner.auto_movement = true
	target_island = Islands.get_neighbor(owner.current_island)
	yield(owner, "body_entered")
	var current_island = owner.get_colliding_bodies()[0]
	target_jump_from = Islands.calculate_jump_point(current_island, target_island)
	pass

func run(delta : float):
	if target_island == null:
		return "Wander"
	if target_jump_from == null:
		return
	
	var to_target = target_jump_from - owner.global_translation
	if(to_target.length() < 3.0):
		owner.AI.states_map["Jump"].target = target_island
		return "Jump"
	
	owner.target_vel = to_target.normalized() * owner.SPEED

func _exit():
	pass
