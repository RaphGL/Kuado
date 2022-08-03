extends KinematicBody2D

onready var mouse_pos = get_global_mouse_position()

func _ready():
	var parent := get_parent()
	position = parent.position
	set_as_toplevel(true)
	look_at(mouse_pos)
