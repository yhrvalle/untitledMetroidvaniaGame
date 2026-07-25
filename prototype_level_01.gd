class_name PrototypeLevel01
extends BaseLevel

@onready var player_spawn: Marker2D = $Entities/PlayerSpawn
@onready var player_camera: Camera2D = $Entities/PlayerCamera


func get_default_player_spawn() -> Vector2:
	return player_spawn.position
	
func get_player_camera() -> Camera2D:
	return player_camera
	
