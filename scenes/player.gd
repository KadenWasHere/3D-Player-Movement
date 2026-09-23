extends CharacterBody3D


const GRAVITY: float = 9.8

@onready var camera: Camera3D = $CameraRig

## Direction the CharacterBody3D is moving
var direction: Vector3
## The actual speed of the player
var speed: float
## How fast a player can walk
@export var walk_speed: float = 2.0
## How fast a player can run
@export var run_speed: float = 4.0
## How high and long a player can jump for
@export var jump_velocity: float = 2.0
## Controls how much a CharacterBody3D can move in the 
## x or z direction when in the air
@export var air_control: float = 2.5
## Controls how fast the CharacterBody3D slows down when
## no input is given
@export var friction: float = 10.0


func _physics_process(delta: float) -> void:
	
	# controls
	var direction_2D: Vector2 = Input.get_vector("backward", "forward", "left", "right")
	direction = (transform.basis * Vector3(direction_2D.y, 0, -direction_2D.x)).normalized()
	
	if Input.is_action_pressed("sprint") and is_on_floor():
		speed = run_speed
	else:
		speed = walk_speed
	
	var target_velocity: Vector3 = direction * speed
	
	if is_on_floor():
		ground_movement(delta, target_velocity)
	else:
		velocity.y -= GRAVITY * delta
		air_movement(delta, target_velocity)

	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()


## Moves the CharacterBody3D when on the ground. When no player input is provided
## the velocity gradually goes to 0 by the amount of [member friction]
func ground_movement(delta: float, target_velocity: Vector3) -> void:
	if direction:
		velocity.x = target_velocity.x
		velocity.z = target_velocity.z
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)


## Moves the CharacterBody3D when in the air. When in the air, movement in
## the x or y direction is restricted by the amount of [member air_control]
func air_movement(delta: float, target_velocity: Vector3) -> void:
	if direction:
		velocity.x = move_toward(velocity.x, target_velocity.x, air_control * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, air_control * delta)
