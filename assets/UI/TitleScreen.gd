extends Node2D

var playButton
var quitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton = $"PlayButton"
	quitButton = $"QuitButton"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	pass # Replace with function body.
	#need a singleton of the player to actually change anythign about the gameplay
	#with UI. this is nonsense, why is it so hard to do this
	#everyone says signals do this. they don't. so when you get back here
	#use a singleton to store global values.
