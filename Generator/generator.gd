extends Node2D
class_name Generator

@export var min_room_width: int = 3
@export var min_room_height: int = 3
@export var max_room_width: int = 500
@export var max_room_height: int = 500
@export var game_width: int = 1600
@export var game_height: int = 1200
@export var tile_map_layer: TileMapLayer = null
@export var draw_outline: bool = false


signal floor_generated
signal floor_is_cleared


func _ready() -> void:
	$GeneratorNode.initialize(min_room_width, min_room_height, max_room_width, max_room_height, game_width,
		game_height, tile_map_layer, draw_outline)
	if get_parent().name == "root":
		$GeneratorNode.generate()
		print(get_player_start())
		floor_generated.emit()


func generate() -> void:
	$GeneratorNode.generate()
	floor_generated.emit()


func clear_floor() -> void:
	$GeneratorNode.clear_floor()
	floor_is_cleared.emit()


func get_player_start() -> Vector2:
	return $GeneratorNode.get_player_start()
