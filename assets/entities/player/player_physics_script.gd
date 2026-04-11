extends RigidBody3D

const SPEED = 10.0
var camera
var canPlay
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $"../CameraSpringArm3D/Camera3D"
	canPlay = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("forward", "back", "right", "left")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
		angular_velocity += direction*SPEED*delta
