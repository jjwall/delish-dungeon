extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const TOP_LANE_Y_POS = 380
const MIDDLE_LANE_Y_POS = 430
const BOTTOM_LANE_Y_POS = 480

var current_lane = "middle" # | "bottom" | "top"

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func try_and_move_up():
	if current_lane != "top":
		if current_lane == "bottom":
			current_lane = "middle"
		else:
			current_lane = "top"
		
		process_lane_change()

func try_and_move_down():
	if current_lane != "bottom":
		if current_lane == "top":
			current_lane = "middle"
		else:
			current_lane = "bottom"
		
		process_lane_change()

func process_lane_change():
	if current_lane == "top":
		position.y = TOP_LANE_Y_POS
	if current_lane == "middle":
		position.y = MIDDLE_LANE_Y_POS
	if current_lane == "bottom":
		position.y = BOTTOM_LANE_Y_POS

func _physics_process(_delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.scale.x = direction
		velocity.x = direction * SPEED
	else:
		$AnimatedSprite2D.play("default")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_up"):
		try_and_move_up()
	
	if Input.is_action_just_pressed("ui_down"):
		try_and_move_down()

	move_and_slide()
