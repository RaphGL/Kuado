extends Area2D

# TODO shoot only one bullet every x time 
export(int) var num_of_bullets = 15
export(int) var reloading_time = 1

onready var height = $GunSprite.texture.get_height()
onready var width = $GunSprite.texture.get_width()
onready var flip_h = false
onready var flip_v = false

var bullets_in_clip = num_of_bullets
var can_shoot := true


func _process(_delta):
	$GunSprite.flip_h = flip_h
	$GunSprite.flip_v = flip_v
	print(bullets_in_clip)

	if Input.is_action_pressed("shoot"):
		shoot_gun()
	if Input.is_action_just_pressed("reload_gun"):
		$Reloading.start()


func shoot_gun() -> void:
	if bullets_in_clip > 0:
		bullets_in_clip -= 1


# time it takes to reload gun
func _on_Reloading_timeout():
	bullets_in_clip = num_of_bullets
