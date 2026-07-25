class_name MainGame
extends Node

const PLAYER_UID : String = "uid://dsk61mfqoiyue"
var player : Player = null
var current_level : BaseLevel = null

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

func load_level(level_scene : String) -> void:
	_deferred_load_level.call_deferred(level_scene)

func _deferred_load_level(level_scene_uid : String) -> void:
	if (current_level != null):
		current_level.queue_free()
		current_level = null

	await get_tree().process_frame
	# need this casting after loading? load(uid, type_hint (?))
	var level_resource : PackedScene = ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	if (level_resource == null):
		push_error("faiou carregar o level uid=" + level_scene_uid)
		return

	current_level = level_resource.instantiate() as BaseLevel
	if (current_level == null):
		push_error("faiou instantiate level uid=" + level_scene_uid)
		return
	level_root.add_child(current_level)
	
	await get_tree().process_frame
	_place_player_at_spawn()
	_setup_level_camera()

func _place_player_at_spawn() -> void:
	if (player == null):
		push_error("faiou colocar o player no spawn location player uid")
		return
	if (current_level == null):
		push_error("nao existe level para spawnar player")
		return

	player.global_position = current_level.get_default_player_spawn()

func _setup_level_camera() -> void:
	if (player == null):
		push_error("faiou colocar a camera no player, pasme ele esta null")
		return
	if (current_level == null):
		push_error("num nem tem nivel para colocar camera")
		return

	var level_camera : Camera2D = current_level.get_player_camera()
	if (level_camera == null):
		push_error("faiou de colocar a camera")
		return
	level_camera.target = player
