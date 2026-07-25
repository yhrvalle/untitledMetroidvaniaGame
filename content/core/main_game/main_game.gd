class_name MainGame
extends Node

const PLAYER_UID : String = "uid://dsk61mfqoiyue"
var player : Player = null
# world nodes
@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

#ui nodes
@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot

func _ready() -> void:
	_init_player()	

func _init_player() -> void:
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_UID) as PackedScene
	if (player_scene == null):
		push_error("faiou o load da player scene id=" + PLAYER_UID)
		return
	
	player = player_scene.instantiate() as Player
	if (player == null):
		push_error("player scene n extende player id=" + PLAYER_UID)
		return
	entity_root.add_child(player)
