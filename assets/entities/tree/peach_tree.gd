extends Node3D

var collider
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Controller.game_Start.connect(_on_Game_Start)
	collider = $"Collider"


func _on_Game_Start() -> void:
	collider.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(1).timeout
	collider.process_mode = Node.PROCESS_MODE_INHERIT
