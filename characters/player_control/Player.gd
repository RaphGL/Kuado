# TODO health
# TODO dodge bar
# TODO gun bullets
extends RigidBody2D

# Health
var hp = 100

# Movement
export(int) var walking_speed := 300
export(int) var flying_speed := 500
onready var linear_vel: Vector2
var can_dodge = false
var on_floor: bool
var allowed_to_fly := true 


# Fuel
export(int) var fuel_consumption := 40
export(int) var refueling := 30
export(int) var max_fuel_amount := 100
onready var amount_of_fuel = max_fuel_amount


func _process(delta):
	handle_vfx()
	manage_fuel(delta)

	# <= 1 because amount_of_fuel is never truly 0
	# it's a few decimals less because of delta
	if amount_of_fuel <= 1:
		allowed_to_fly = false
	if on_floor and amount_of_fuel > max_fuel_amount * 0.3: 
		allowed_to_fly = true


func _physics_process(_delta) -> void:
	# Basic Player Control
	if Input.is_action_pressed("ui_right"):
		linear_vel = get_linear_velocity()
		if on_floor:
			set_linear_velocity(Vector2(walking_speed, linear_vel.y))
		else:
			set_linear_velocity(Vector2(flying_speed * 0.7, linear_vel.y))

	if Input.is_action_pressed("ui_left"):
		linear_vel = get_linear_velocity()
		if on_floor:
			set_linear_velocity(Vector2(-walking_speed, linear_vel.y))
		else:
			set_linear_velocity(Vector2(-flying_speed * 0.7, linear_vel.y))

	if Input.is_action_pressed("ui_down"):
		linear_velocity = Vector2(linear_velocity.x, linear_velocity.abs().y)

	# only go up if tank is not empty
	if allowed_to_fly and amount_of_fuel > 0 and Input.is_action_pressed("ui_up"):
			linear_vel = get_linear_velocity()
			set_linear_velocity(Vector2(linear_vel.x, -flying_speed).normalized() * flying_speed)
	# makes sure camera is smooth
	$PlayerCamera.align()

	# Dodge attacks and dash
	if Input.is_action_just_pressed("dodge") and can_dodge:
		var lv := linear_velocity.normalized() * flying_speed * 6
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			linear_velocity = Vector2(lv.x, 0)
			can_dodge = false
		if Input.is_action_pressed("ui_up") \
			and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
			linear_velocity = lv
			can_dodge = false
		if Input.is_action_pressed("ui_up"):
			linear_velocity = Vector2(0, lv.y)
			can_dodge = false


func handle_vfx() -> void:
	# Mouse events
	var mouse_pos := get_global_mouse_position()
	if mouse_pos.x > position.x and $PlayerSprite.flip_h:
		$PlayerSprite.flip_h = false
	if mouse_pos.x < position.x and not $PlayerSprite.flip_h:
		$PlayerSprite.flip_h = true


func manage_fuel(delta) -> void:
	if not on_floor:
		# consume fuel if going up
		if amount_of_fuel > 0 and linear_velocity.normalized().y < 0:
			amount_of_fuel -= fuel_consumption * delta
		# make sure it refuels if falling
		elif amount_of_fuel < max_fuel_amount and linear_velocity.normalized().y > 0:
			amount_of_fuel += refueling * delta
	else:
		# refuel if on ground
		if amount_of_fuel < max_fuel_amount:
			amount_of_fuel += refueling * delta
	if amount_of_fuel >= max_fuel_amount:
		$Progress/ProgressEnd.visible = true
	else:
		$Progress/ProgressEnd.visible = false

	$Progress/ProgressBar.value = amount_of_fuel


# Registers when body is on ground
func _on_Player_body_entered(_body):
	on_floor = true

# Registers when body leaves ground
func _on_Player_body_exited(_body):
	on_floor = false

func _on_DodgeTimeOut_timeout():
	can_dodge = true
