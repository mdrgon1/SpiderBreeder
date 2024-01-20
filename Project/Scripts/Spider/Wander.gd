extends Node

var new_target_timer : SceneTreeTimer = null

var queue_idle = false
var queue_idle_timer: SceneTreeTimer = null

func _enter() -> void:
	queue_idle = false
	set_target_vel()
	queue_idle_timer = get_tree().create_timer(rand_range(0.1, 10.0))
	queue_idle_timer.connect("timeout", self, "set_queue_idle")
	owner.auto_movement = true


func run(delta : float):
	if queue_idle:
		return "Idle"


func _exit() -> void:
	if new_target_timer:
		new_target_timer.disconnect("timeout", self, "set_target_vel")
	if queue_idle_timer:
		queue_idle_timer.disconnect("timeout", self, "set_queue_idle")


func set_target_vel() -> void:
	owner.target_vel = Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized() * owner.SPEED
	new_target_timer = get_tree().create_timer(rand_range(0.5, 1.5))
	new_target_timer.connect("timeout", self, "set_target_vel")


func set_queue_idle() -> void:
	queue_idle = true
	queue_idle_timer = null
