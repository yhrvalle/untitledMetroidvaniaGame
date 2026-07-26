class_name PlayerCamera
extends Camera2D

var target : Node2D = null

func _physics_process(delta: float) -> void:
	_follow_target(delta)

func _follow_target(_delta : float) -> void:
	if(!target):
		return
	global_position = target.global_position
