extends Node

var canMove = false
var distance = 0 #the bar that ticks up showing how close to 100m the player has traveled
var totDistance = 0 #the number of times the player has filled the distance bar
var health = 3
signal game_Start
signal game_Over

func _healthChange (i):
	health += i
	if (health <= 0):
		game_Over.emit()
		canMove = false

func _gameStart():
	canMove = true
	health = 3
	game_Start.emit()
