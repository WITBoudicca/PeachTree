extends Node3D

var collider
var growAnim
var growSound
var peachLoc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Controller.game_Start.connect(_on_Game_Start)
	collider = $"Collider"
	growAnim = $GrowAnim
	peachLoc = $PeachSpawnLoc
	growSound = $GrowSound

func _on_Game_Start() -> void:
	collider.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(1).timeout
	collider.process_mode = Node.PROCESS_MODE_INHERIT
	
func _on_Dying_Anim() -> void:
	growAnim.play("Grow")
	growSound.play()

func _jump() -> void:
	growAnim.play("Grow")
	growSound.play()
	collider.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(1).timeout
	collider.process_mode = Node.PROCESS_MODE_INHERIT

func _move_Peach(p: Node3D) -> void:
	p.global_position = peachLoc.global_position
