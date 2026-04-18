extends SpringArm3D

@export var mouse_sensibility: float = 0.0005
var cameraModeBool = false

func changeCamera() -> void:
	if (cameraModeBool == true):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if (cameraModeBool == false):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x * mouse_sensibility
			rotation.y = wrapf(rotation.y, 0.0, TAU)
			
			rotation.x -= event.relative.y * mouse_sensibility
			rotation.x = clamp(rotation.x, -PI/2, PI/4)
	
func _process(_delta: float) -> void:
	if (Controller.canMove == true):
		if (cameraModeBool == false):
			changeCamera()
			cameraModeBool = !cameraModeBool
	if (Controller.canMove == false):
		if (cameraModeBool == true):
			changeCamera()
			cameraModeBool = !cameraModeBool
		rotation.y -= 0.001
