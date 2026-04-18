extends Node

var canMove = false
var distance = 0.0 #the bar that ticks up showing how close to 100m the player has traveled
const MAXDISTTOTOT = 100 #how high distance has to be to turn into a pip of TotDistance
var totDistance = 1 #the number of times the player has filled the distance bar
var health = 3
signal game_Start
signal take_Damage
signal game_Over
signal restart

func _healthChange (i):
	health += i
	print(health)
	if (health <= 0):
		game_Over.emit()
		canMove = false #stops the player from moving until they press play again
	else:
		take_Damage.emit()

func _gameStart():
	canMove = true
	health = 3
	distance = 0.0
	totDistance = 1
	game_Start.emit()
	
func _endAnim():
	restart.emit()
