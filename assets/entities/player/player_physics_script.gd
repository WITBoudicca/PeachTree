extends RigidBody3D

const SPEED = 15.0
const MAXSPEED = 15.0 #for limiting our speed cause damn this peach can roll

var camera
var jumpDetect
var grav = 1

#signal jumpPressed
var airborne = false
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $"../CameraSpringArm3D/Camera3D"
	jumpDetect = $"../JumpDetection"
	Controller.game_Start.connect(_on_Game_Start)
	Controller.game_Over.connect(_on_Game_End)
	gravity_scale = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (Controller.canMove):
		var input_dir = Input.get_vector("forward", "back", "right", "left")
		var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
			angular_velocity += direction*SPEED*delta
			if (angular_velocity.x > MAXSPEED): angular_velocity.x = MAXSPEED #this is jank but it'll work so i don't care
			if (angular_velocity.y > MAXSPEED): angular_velocity.y = MAXSPEED
			if (angular_velocity.z > MAXSPEED): angular_velocity.z = MAXSPEED
		
		if airborne == false and Input.is_key_pressed(KEY_SPACE):
			linear_velocity.y += 7.5
			airborne = true
			#jumpPressed.emit()

#func _on_jump_delay_timeout(): #commenting this out and using collision to detect when the player is grounded to avoid double jumps and coyote jumps
	#airborne = false			#still this timer code is good i'm gonna steal it for despawning old track bits

func _on_Game_Start():
	gravity_scale = grav
	
func _on_Game_End():
	pass
	#here we want to stop all play velocity and movement,
	#spawn a peach tree out of the dead player, maybe play
	#an anim of the peach splitting open, and then move the player
	#back up onto the tree branch of the new peach tree


func _on_jump_detection_body_entered(_body: Node3D) -> void:
	airborne = false
