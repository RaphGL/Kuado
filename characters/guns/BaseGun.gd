extends Area2D

# TODO make shooting with raycast collider
export(int) var num_of_bullets = 15
export(int) var reloading_time = 1
export(int) var damage = 2

onready var height = $GunSprite.texture.get_height()
onready var width = $GunSprite.texture.get_width()
onready var flip_h := false
onready var flip_v := false
onready var parent_id := get_parent().get_instance_id()

var bullets_in_clip = num_of_bullets
var can_shoot := true


func _process(_delta):
	var mouse_pos := get_global_mouse_position()
	look_at(mouse_pos)

	$GunSprite.flip_h = flip_h
	$GunSprite.flip_v = flip_v
	$AimSprite.flip_h = flip_h
	$AimSprite.flip_v = flip_v


func _physics_process(_delta):
	if Input.is_action_pressed("shoot"):
		shoot_gun()
	if Input.is_action_just_pressed("reload_gun"):
		$Reloading.start()


func shoot_gun() -> void:
	if bullets_in_clip > 0 and can_shoot:
		bullets_in_clip -= 1
		can_shoot = false
		if $GunTarget.is_colliding():
			var collider = $GunTarget.get_collider()
			if collider.get_instance_id() != get_parent().get_instance_id() and collider.has_method("receive_damage"):
				collider.receive_damage(damage)
		$Shooting.start()


# time it takes to reload gun
func _on_Reloading_timeout():
	bullets_in_clip = num_of_bullets


func _on_Shooting_timeout():
	can_shoot = true
