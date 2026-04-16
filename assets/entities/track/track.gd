extends Node3D

var hasSpawned = false
signal _start_despawn
signal _pause_despawn
var trackList = []
var trackSpawnLoc
var respawnLoc
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trackList.append(load("res://assets/entities/track/hill_track.tscn"))
	trackList.append(load("res://assets/entities/track/hole_track.tscn"))
	trackList.append(load("res://assets/entities/track/jump_track.tscn"))
	trackList.append(load("res://assets/entities/track/track.tscn"))
	trackSpawnLoc = position
	trackSpawnLoc.z -= 75*3
	trackSpawnLoc.y -= 8.5*3
	respawnLoc = position
	print(respawnLoc)
	respawnLoc.z -= 3
	respawnLoc.y += 4




func _on_area_3d_body_entered(body: Node3D) -> void: #should have renamed this but it's for the track spawn area at the end of the track
	
	if (body.is_in_group("Player") && hasSpawned == false):
		#print(trackSpawnLoc)
		#print(position)
		var rand = int(randf_range(0,trackList.size()-1))
		var newTrack = trackList[rand].instantiate()
		newTrack.position = trackSpawnLoc
		get_parent().add_child(newTrack)
		
		_start_despawn.emit()
		hasSpawned = true
	if (body.is_in_group("Player") && hasSpawned == true):
		_start_despawn.emit()


func _on_despawn_delay_timeout() -> void:
	queue_free()


func _on_fall_off_area_body_entered(body: Node3D) -> void: #this one's for fall off
	if body.is_in_group("Player"): #puts the player back up top, resets the despawn timer if it's started, and deals 1 damage to the player
		body.position = respawnLoc
		Controller._healthChange(-1)
		_pause_despawn.emit()
