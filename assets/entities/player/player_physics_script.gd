extends RigidBody3D
#Physics/control variables
const SPEED = 15.0
const MAXSPEED = 20.0 #for limiting our speed cause damn this peach can roll
const MINSPEED = 7.0
const GRAV = 1
const HURTINVULNTIMER = 2.0
var jumpDetect
var airborne = false
var camera
var hurtInvuln = true

#Distance Tracking
var lastFramePos
#Audio Variables
var gameMusic
var menuMusic
var maxVolume = 1.0
var minVolume = 0.0
var volumeTimer = 100.0
var gameVolume = minVolume
var menuVolume = maxVolume
#Animation Variables
var Anim
var peachTree #reference of the peachtree asset for spawning

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $"../CameraSpringArm3D/Camera3D"
	gameMusic = $"../CameraSpringArm3D/Camera3D/GameMusic"
	menuMusic = $"../CameraSpringArm3D/Camera3D/MenuMusic"
	jumpDetect = $"../JumpDetection"
	Anim = $"CollisionShape3D/PeachVis/PlayerAnimator"
	peachTree = load("res://assets/entities/tree/peach_tree.tscn")
	gameMusic.set_volume_linear(gameVolume)
	menuMusic.set_volume_linear(menuVolume)
	jumpDetect = $"../JumpDetection"
	Controller.game_Start.connect(_on_Game_Start)
	Controller.game_Over.connect(_on_Game_End)
	Controller.take_Damage.connect(_on_Damage)
	gravity_scale = 0
	lastFramePos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (Controller.canMove && airborne == false):
		var input_dir = Input.get_vector("forward", "back", "right", "left")
		var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
			angular_velocity += direction*SPEED*delta
		if airborne == false and Input.is_key_pressed(KEY_SPACE):
			linear_velocity.y += 7.5
			airborne = true
	#Limiting max speed with a thousand if statements, just change MAXSPEED up top to whatever number works
	if (abs(angular_velocity.x) > MAXSPEED): angular_velocity.x = MAXSPEED * sign(angular_velocity.x) #this is jank but it'll work so i don't care
	if (abs(angular_velocity.y) > MAXSPEED): angular_velocity.y = MAXSPEED * sign(angular_velocity.y)
	if (abs(angular_velocity.z) > MAXSPEED): angular_velocity.z = MAXSPEED * sign(angular_velocity.z)
	#Damage Code
	if (Controller.canMove && !hurtInvuln && abs(angular_velocity.x) + abs(angular_velocity.y) + abs(angular_velocity.z) <= MINSPEED):
		Controller._healthChange(-1)
	#DISTANCE TRACKING
	Controller.distance += (position.z - lastFramePos.z) * -1
	lastFramePos = position
	if (Controller.distance >= Controller.MAXDISTTOTOT):
		Controller.distance = 0
		Controller.totDistance += 1
	
func _process(_delta: float) -> void: #i think my coding instructors would be right to kill me for this function but i love all my children and i'm too tired to think of something better
		gameMusic.set_volume_linear(gameVolume)
		menuMusic.set_volume_linear(menuVolume)
#func _on_jump_delay_timeout(): #commenting this out and using collision to detect when the player is grounded to avoid double jumps and coyote jumps
	#airborne = false			#still this timer code is good i'm gonna steal it for despawning old track bits

func _on_Game_Start():
	gravity_scale = GRAV
	linear_velocity.z += -10
	linear_velocity.y += 2
	var tween = get_tree().create_tween()
	tween.tween_property(self,"gameVolume",maxVolume,volumeTimer)
	tween.tween_property(self,"menuVolume",minVolume,volumeTimer)
	hurtInvuln = true
	await get_tree().create_timer(HURTINVULNTIMER).timeout
	hurtInvuln = false
	
func _on_Game_End():
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	gravity_scale = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(self,"gameVolume",minVolume,volumeTimer)
	tween.tween_property(self,"menuVolume",maxVolume,volumeTimer)
	#here we want to stop all play velocity and movement,
	#spawn a peach tree out of the dead player, maybe play
	#an anim of the peach splitting open, and then move the player
	#back up onto the tree branch of the new peach tree

func _on_Damage():
	Anim.play("Hurt")
	hurtInvuln = true
	await get_tree().create_timer(HURTINVULNTIMER).timeout
	hurtInvuln = false

func _on_jump_detection_body_entered(_body: Node3D) -> void:
	airborne = false


func _on_jump_detection_body_exited(_body: Node3D) -> void:
	airborne = true
