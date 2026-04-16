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
	Controller.game_Over.connect(_controller_game_over)
	Controller.game_Start.connect(_controller_game_start)



func _on_play_button_pressed() -> void:
	Controller._gameStart()



func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _process(_delta: float) -> void: #it's obviously bad to do the pips in the update function but i've got less than a week and i just want the ui to work so it'll work for now
	if (Controller.canMove):
		distanceBar.value = Controller.distance
		distancePips.text = ""
		for i in range(Controller.totDistance):
			distancePips.text += "O"

func _controller_game_over():
	playUI.visible = false
	titleScreen.visible = true

func _controller_game_start():
	titleScreen.visible = false
	playUI.visible = true
