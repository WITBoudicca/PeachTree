extends Node2D

var titleScreen
var playButton
var quitButton

var playUI
var distanceBar
var distancePips
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton = $"TitleScreen/PlayButton"
	quitButton = $"TitleScreen/QuitButton"
	titleScreen = $"TitleScreen"
	playUI = $"PlayUI"
	distanceBar = $"PlayUI/DistanceBar"
	distancePips = $"PlayUI/DistancePips"



func _on_play_button_pressed() -> void:
	playUI.visible = true
	
	Controller.canMove = true
	print(Controller.canMove)
	titleScreen.visible = false



func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _process(_delta: float) -> void: #it's obviously bad to do the pips in the update function but i've got less than a week and i just want the ui to work so it'll work for now
	if (Controller.canMove):
		distanceBar.value = Controller.distance
		distancePips.text = ""
		for i in range(Controller.totDistance):
			distancePips.text += "O"
