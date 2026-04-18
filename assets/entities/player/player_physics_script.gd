extends RigidBody3D
#Physics/control variables
const SPEED = 15.0
const MAXSPEED = 20.0 #for limiting our speed cause damn this peach can roll
const MINSPEED = 8.0
const GRAV = 1
const HURTINVULNTIMER = 3.0
var jumpDetect
var airborne = false
var camera
var hurtInvuln = true

#Distance Tracking
var lastFramePos
#Audio Variables
var gameMusic
var menuMusic
var maxVolume = 3.0
var minVolume = -80.0
var volumeTimer = 1.0
var gameVolume = minVolume
var menuVolume = maxVolume
var landSFX
#Animation Variables
var Anim
var peachTree #reference of the peachtree asset for spawning
var splitPeach #reference of the splitPeach asset for spawning
var peachVis #reference for the player visuals, so we can turn them off while the tree is spawning
var fruitCrack

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $"../CameraSpringArm3D/Camera3D"
	gameMusic = $"../CameraSpringArm3D/Camera3D/GameMusic"
	menuMusic = $"../CameraSpringArm3D/Camera3D/MenuMusic"
	jumpDetect = $"../JumpDetection"
	Anim = $"CollisionShape3D/PlayerAnimator"
	peachTree = load("res://assets/entities/tree/peach_tree.tscn")
	splitPeach = load("res://assets/entities/player/split_peach.tscn")
	peachVis = $CollisionShape3D/PeachVis
	gameMusic.set_volume_db(gameVolume)
	menuMusic.set_volume_db(menuVolume)
	fruitCrack = $"../CameraSpringArm3D/Camera3D/FruitCrack"
	jumpDetect = $"../JumpDetection"
	landSFX = $"../CameraSpringArm3D/Camera3D/LandSFX"
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
		if airborne == false and Input.is_key_pressed(KEY_SPACE): #last minute, but now in order to jump you ahve to spend one of your total distance pips, which grows a peach tree underneath you
			if (Controller.totDistance > 0):
				Controller.totDistance -= 1
				linear_velocity.y += 10
				airborne = true
				var newTree = peachTree.instantiate()
				newTree.rotation.y = randf_range(-180,180)
				newTree.scale = Vector3(1,1,1) * randf_range(0.2,0.6)
				newTree.position = position
				get_parent().add_child(newTree)
				newTree._jump()
				
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
		gameMusic.set_volume_db(gameVolume)
		menuMusic.set_volume_db(menuVolume)
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
	fruitCrack.play()
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	gravity_scale = 0.0
	await get_tree().create_timer(7).timeout
	peachVis.visible = false
	var newSplit = splitPeach.instantiate()
	newSplit.position = position
	get_parent().add_child(newSplit)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"gameVolume",minVolume,volumeTimer)
	tween.tween_property(self,"menuVolume",maxVolume,volumeTimer)
	var newTree = peachTree.instantiate()
	newTree.position = position
	newTree.rotation.y = randf_range(-180,180)
	newTree.scale += Vector3(1.0,1.0,1.0)*(float(Controller.totDistance)/10)
	get_parent().add_child(newTree)
	newTree._on_Dying_Anim()
	await get_tree().create_timer(3).timeout
	newTree._move_Peach(self)
	peachVis.visible = true
	Anim.play("Spawn")
	await get_tree().create_timer(1).timeout
	Controller._endAnim()

func _on_Damage():
	Anim.play("Hurt")
	hurtInvuln = true
	await get_tree().create_timer(HURTINVULNTIMER).timeout
	hurtInvuln = false

func _on_jump_detection_body_entered(_body: Node3D) -> void:
	airborne = false
	landSFX.play()


func _on_jump_detection_body_exited(_body: Node3D) -> void:
	airborne = true
