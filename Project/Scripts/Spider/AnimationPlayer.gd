extends AnimationPlayer

func _ready() -> void:
	play("idle-loop")

func run():
	if current_animation != "run-loop":
		play("run-loop")

func idle():
	if current_animation != "idle-loop":
		play("idle-loop")
