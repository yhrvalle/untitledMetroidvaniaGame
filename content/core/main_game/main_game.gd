class_name MainGame
extends Node
# NOTE: assert() é para usar em erro do programador
# NOTE: defensive programming é para runtime

#cuidado com o uid, é pra puxar a SCENE não o script, script tbm tem uid
const PLAYER_UID : String = "uid://dsk61mfqoiyue"
const PROTOTYPE_LEVEL : String = "uid://ci15bm4spgnd2"

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
	load_level(PROTOTYPE_LEVEL)

func _input(event: InputEvent) -> void:
	if (!OS.is_debug_build()):
		return
	if (event.is_action_pressed("debug_quit")):
		print_orphan_nodes()
		_quit_game()

func _quit_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _init_player() -> void:
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_UID) as PackedScene
	if (player_scene == null):
		push_error("faiou o load da player scene id=" + PLAYER_UID)
		return
	player = player_scene.instantiate() as Player

	assert(player != null, "player_scene tem que herdar Player")
	entity_root.add_child(player)

func load_level(level_scene : String) -> void:
	_deferred_load_level.call_deferred(level_scene)

func _deferred_load_level(level_scene_uid : String) -> void:
	if (is_instance_valid(current_level)):
		current_level.queue_free()
		current_level = null
		await get_tree().process_frame

	var level_resource : PackedScene = ResourceLoader.load(level_scene_uid,
	"PackedScene") as PackedScene
	if (level_resource == null):
		push_error("faiou carregar o level uid=" + level_scene_uid)
		return

	current_level = level_resource.instantiate() as BaseLevel
	assert(current_level != null, "current_level scene tem que herdar BaseLevel")

	level_root.add_child(current_level)

	_place_player_at_spawn()
	_setup_level_camera()

func _place_player_at_spawn() -> void:
	assert(player != null, "faiou colocar plauyer no spawn location")
	assert(current_level != null, "nao existe level para spawnar player")

	player.global_position = current_level.get_default_player_spawn()

func _setup_level_camera() -> void:
	assert(player != null, "faiou colocar a camera no player, pasme ele esta null")
	assert(current_level != null, "num nem tem nivel para colocar camera")

	var level_camera : Camera2D = current_level.get_player_camera()
	assert(level_camera != null, "faiou de colocar a camera")
	level_camera.target = player
