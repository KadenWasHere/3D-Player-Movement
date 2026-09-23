extends Camera3D

@export var sensitivity: float = 0.003
@export var max_rot: float = deg_to_rad(-40)
@export var min_rot: float = deg_to_rad(60)



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pass
		#head.rotate_x(-event.relative.y * sensitivity)
		#player_view.rotate_y(-event.relative.x * sensitivity)
