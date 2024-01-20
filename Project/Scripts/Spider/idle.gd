extends Node


var queue_wander = false
var queue_wander_timer: SceneTreeTimer = null


func _enter() -> void:
	owner.target_vel = Vector3.ZERO
	queue_wander = false
	queue_wander_timer = get_tree().create_timer(rand_range(0.1, 5.0))
	queue_wander_timer.connect("timeout", self, "set_queue_wander")
	owner.auto_movement = true

func run(delta : float):
	if queue_wander:
		return "Wander"

func _exit() -> void:
	if queue_wander_timer:
		queue_wander_timer.disconnect("timeout", self, "set_queue_wander")


func set_queue_wander() -> void:
	queue_wander = true
	queue_wander_timer = null
