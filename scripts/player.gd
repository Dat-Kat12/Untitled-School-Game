extends CharacterBody3D

@onready var Head = $Head

var current_speed = 3.0

const walking_speed = 3.0
const sprinting_speed = 5.0
 

const JUMP_VELOCITY = 0

const mouse_sense = 0.4
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * mouse_sense))

func _physics_process(delta: float) -> void:
	# Add the gravity.
		# Sprint 
	if Input.is_action_pressed("sprint"):
		current_speed = sprinting_speed
	else:
		current_speed = walking_speed
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
