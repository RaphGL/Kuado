extends KinematicBody2D

var velocity := 1000

onready var mouse_pos = get_global_mouse_position()

func _ready():
	set_as_toplevel(true)
	look_at(mouse_pos)
	# makes bullet appear from the end of the gun
	var gun_width := Vector2(get_parent().width, 0).rotated(rotation)
	position += gun_width

func _physics_process(delta):
	# TODO bullet stops upon reaching mouse position
	position = position.move_toward(mouse_pos, velocity * delta)
