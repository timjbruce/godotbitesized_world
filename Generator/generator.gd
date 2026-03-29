extends Node2D
class_name Generator

@export var rows: int = 3
@export var columns: int = 5
@export var min_space_between_rooms: int = 3
@export_range(.6, 1.0) var min_room_width: float = .6
@export_range(.6, 1.0) var min_room_height: float = .6
@export var max_room_width: int = 500
@export var max_room_height: int = 500
@export var game_width: int = 1600
@export var game_height: int = 1200
@export var tile_map_layer: TileMapLayer = null
@export var draw_outline: bool = true


signal floor_generated
signal floor_is_cleared


func _ready() -> void:
	var generator_data: GeneratorData = GeneratorData.new(
		rows, columns, min_space_between_rooms, 
		min_room_width, min_room_height, max_room_width, max_room_height,
		game_width, game_height, tile_map_layer, draw_outline)
	$GeneratorNode.initialize(generator_data)
	if get_parent().name == "root":
		$GeneratorNode.generate()
		floor_generated.emit()


func generate() -> void:
	$GeneratorNode.generate()
	floor_generated.emit()


func clear_floor() -> void:
	$GeneratorNode.clear_floor()
	floor_is_cleared.emit()


func get_player_start() -> Vector2i:
	return $GeneratorNode.get_player_start()


func get_random_location() -> Vector2i:
	return $GeneratorNode.get_random_location()
