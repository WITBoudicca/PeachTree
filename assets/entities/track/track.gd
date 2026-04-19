extends Node3D

#Track Variables
var hasSpawned = false
signal _start_despawn
signal _pause_despawn
var trackList = []
var trackSpawnLoc
var respawnLoc
#Obstacle Variables
var obstacleList = []
var raycastChecker
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
	respawnLoc.z -= 3
	respawnLoc.y += 4
	
	raycastChecker = $"ObstSpawnChecker"
	obstacleList.append(load("res://assets/entities/obstacles/bush.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/log.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/bush.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/log.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/rock.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/rock.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/rock_cluster.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/berriless_bush.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/berriless_bush.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/berriless_bush.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/stump.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/stump.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/dead_tree.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/hollow_log.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/crappy_fence.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/crappy_fence.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/flat_rock.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/grass_flowers.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/tall_grass.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/flat_rock.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/tall_grass.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/flat_rock.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/tall_grass.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/flat_rock.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/tall_grass.tscn"))
	obstacleList.append(load("res://assets/entities/obstacles/jerald.tscn"))
	#new obstacles get put here obv, following same format as above
	for i in (Controller.totDistance+12):
		#picking a random obstacle from the list and spawning it
		var rand = int(randf_range(0,obstacleList.size()))
		var newObst = obstacleList[rand].instantiate()
		#setting a random size and rotation to the object to make it look a little nicer
		var randrot = randf_range(-180,180)
		var randscale = randf_range(0.5,1.5)
		newObst.rotation.y = randrot
		newObst.scale = Vector3(randscale,randscale,randscale)
		#picking a random location above the current track piece, drawing a raycast down until we find a valid spawn location, and taking the track position at that point and snapping it to that
		var obstSpawnLoc
		var randX = randf_range(-20,20)
		var randZ = randf_range(-75,0)
		obstSpawnLoc = Vector3(randX,raycastChecker.position.y,randZ)
		raycastChecker.position = obstSpawnLoc
		raycastChecker.force_raycast_update()
		if (raycastChecker.is_colliding()):
			obstSpawnLoc.y = to_local(raycastChecker.get_collision_point()).y
			newObst.position = obstSpawnLoc
			add_child(newObst)
			
			
		




func _on_area_3d_body_entered(body: Node3D) -> void: #should have renamed this but it's for the track spawn area at the end of the track
	
	if (body.is_in_group("Player") && hasSpawned == false):
		var rand = int(randf_range(0,trackList.size()))
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
