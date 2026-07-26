class_name DebugHud
extends Control

@onready var fps_label: Label = %FpsLabel
@onready var version_label: Label = %VersionLabel
@onready var currently_build: Label = %CurrentlyBuild

func _ready() -> void:
	_set_version_label()

func _process(_delta: float) -> void:
	fps_label.set_text("FPS: " + str(Engine.get_frames_per_second()))
	
func _set_version_label() -> void:
	version_label.set_text("Build: " + ProjectSettings.get_setting("application/config/version"))
