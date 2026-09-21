extends CharacterBody3D


const GRAVITY: float = 9.8

# movement variables
var direction: Vector2
@export var walk_speed: int = 4
@export var run_speed: int = 10
@export var jump_velocity: float = 4.5

# rotation variables in radians
@export var sensitivity: float = 0.003
var rot_x: float
var rot_y: float
var max_rot: float = deg_to_rad(-40)
var min_rot: float = deg_to_rad(60)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# walking
	direction = Input.get_vector("left", "right", "forward", "backward")
	velocity.x = direction.x * walk_speed
	velocity.z = direction.y * walk_speed
	
	# jump
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		# adds the new rotation to the total rotation
		rot_x -= event.relative.x * sensitivity
		rot_y -= event.relative.y * sensitivity
		
		# limit amount you can look up or down
		rot_y = clampf(rot_y, min_rot, max_rot)
		
		# resets to basis matrix
		$PlayerView.transform.basis = Basis()
		
		# just sets the basis immedietly to accumilated rotation
		rotate_object_local(Vector3(0, 1, 0), rot_x)
		rotate_object_local(Vector3(1, 0, 0), rot_y)
		
