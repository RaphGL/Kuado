extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FLIGHT_VELOCITY = JUMP_VELOCITY / 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movement
var can_dodge := true
var can_fly := true

# Fuel
const FUEL_PER_SECOND := 40 # how much fuel it takes per second of flight
const REFUEL_PER_SECOND := 30
const MAX_FUEL := 100
@onready var fuel_amount: float = MAX_FUEL


func manage_fuel(delta) -> void:
	# TODO not refueling
	if not is_on_floor() and fuel_amount > 0 and velocity.normalized().y < 0:
		fuel_amount -= FUEL_PER_SECOND * delta
	elif fuel_amount < 100:
		fuel_amount += REFUEL_PER_SECOND * delta
	$"%PlayerBoost".value = fuel_amount
	
	if fuel_amount <= 1:
		can_fly = false
	if is_on_floor() and fuel_amount > MAX_FUEL * 0.3: 
		can_fly = true


func manage_dodge(delta) -> void:
	# TODO make dodge work in any direction
	pass


func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Flying controls
	if Input.is_action_pressed("up") and can_fly:
		velocity.y = FLIGHT_VELOCITY
	
	if Input.is_action_just_pressed("down"):
		velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	var mouse_pos := get_global_mouse_position()
	var sprite := $"%PlayerSprite"
	if mouse_pos.x > position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	manage_fuel(delta)
	manage_dodge(delta)


func _on_dodge_timer_timeout():
	can_dodge = true
