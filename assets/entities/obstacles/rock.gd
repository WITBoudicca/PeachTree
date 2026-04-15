extends Node3D

signal player_Impact

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		player_Impact.emit()
