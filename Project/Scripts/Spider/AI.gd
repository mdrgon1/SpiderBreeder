extends Node

var states_map := {}
var current_state : Node


func _ready() -> void:
	for child in get_children():
		states_map[child.get_name()] = child
	current_state = get_children()[0]
	current_state._enter()


func _process(delta : float) -> void:
	var new_state = current_state.run(delta)
	if new_state:
		enter_state(new_state)


func enter_state(new_state: String) -> void:
	current_state._exit()
	current_state = states_map[new_state]
	current_state._enter()
