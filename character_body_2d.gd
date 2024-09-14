#extends CharacterBody2D
#
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -500.0
#const gravity = 900
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()


extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const gravity = 900

var raycast_len = 500
var grappling_point = Vector2(raycast_len, 0)
var is_grappling = false
var grapple_spd = 1000
var dir_to_mouse = Vector2()

@onready var raycast = $RayCast2D

func _physics_process(delta):
	# Add the gravity if not grappling.
	if not is_on_floor() and not is_grappling:
		velocity.y += gravity * delta

	# Handle jumping if not grappling.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_grappling:
		velocity.y = JUMP_VELOCITY

	# Handle normal left-right movement if not grappling.
	if not is_grappling:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Grappling hook logic
	var mouse_pos = get_global_mouse_position()
	dir_to_mouse = (mouse_pos - global_position).normalized()
	print(raycast)
	raycast.target_position = dir_to_mouse * raycast_len

	# Detect grapple release
	if is_grappling and Input.is_action_just_released('grapple'):
		is_grappling = false

	# Detect grapple collision
	if raycast.is_colliding():
		grappling_point = raycast.get_collision_point()

	# Initiate grappling when the grapple button is pressed
	if Input.is_action_just_pressed('grapple'):
		is_grappling = true

	# Grapple movement
	if is_grappling:
		var dir = (grappling_point - global_position).normalized()
		velocity = dir * grapple_spd
		
		if global_position.distance_to(grappling_point) < 32:
			is_grappling = false
	
	# Move the character using the calculated velocity
	move_and_slide()

func _draw() -> void:
	# Draw the grappling hook ray for visual aid
	draw_circle(global_position + dir_to_mouse * raycast_len, 8, Color.WHITE)
