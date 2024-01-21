extends Node

const SPEED := 30.0
const SENSITIVITY := 0.002

func _input(event):
	if event is InputEventMouseMotion:
		owner.camera.rotate_x(-event.relative.y * SENSITIVITY)
		owner.rotate_y(-event.relative.x * SENSITIVITY)

func _physics_process(delta) -> void:
	var forward : Vector3 = -owner.transform.basis.z
	var right : Vector3 = owner.transform.basis.x
	
	var input := get_input_vec()
	var vel := input.y * forward + input.x * right
	vel *= SPEED
	
	owner.move_and_slide(vel, Vector3.UP)

func get_input_vec() -> Vector2:
	var out := Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		out.x -= 1.0
	if Input.is_action_pressed("move_right"):
		out.x += 1.0
	if Input.is_action_pressed("move_backward"):
		out.y -= 1.0
	if Input.is_action_pressed("move_forward"):
		out.y += 1.0
	
	return out
