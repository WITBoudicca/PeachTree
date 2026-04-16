extends Timer

var maxTime = 10

#func _on_player_rigid_body_jump_pressed():
	#start()


func track_start_despawn() -> void:
	start()
	
func track_stop_despawn() -> void:
	stop()
