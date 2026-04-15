extends RigidBody3D

const SPEED = 15.0

var camera
var canPlay

signal jumpPressed
var airborne = false
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $"../CameraSpringArm3D/Camera3D"
	canPlay = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (Controller.canMove):
		var input_dir = Input.get_vector("forward", "back", "right", "left")
		var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
			angular_velocity += direction*SPEED*delta
		
		if airborne == false and Input.is_key_pressed(KEY_SPACE):
			linear_velocity.y += 7.5
			airborne = true
			jumpPressed.emit()

func _on_jump_delay_timeout():
	airborne = false
