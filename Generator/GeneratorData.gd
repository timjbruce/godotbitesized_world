class_name GeneratorData
extends RefCounted

var rows: int
var columns: int
var min_space_between_rooms: int
var min_room_width: int
var min_room_height: int
var max_room_width: int 
var max_room_height: int
var game_width: int
var game_height: int
var tile_map_layer: TileMapLayer
var draw_outline: bool
var rooms: int
var hor_hallway_height: int
var ver_hallway_width: int

func _init(inc_rows, inc_columns, inc_min_space_between_rooms, 
		inc_min_room_width, inc_min_room_height, inc_max_room_width, 
		inc_max_room_height, inc_game_width, inc_game_height, 
		inc_tile_map_layer, inc_draw_outline) -> void:
	rows = inc_rows
	columns = inc_columns
	min_space_between_rooms = inc_min_space_between_rooms
	min_room_width = int(inc_min_room_width * inc_max_room_width)
	min_room_height = int(inc_min_room_height * inc_max_room_height)
	hor_hallway_height = int((inc_min_room_height - .5) * inc_max_room_height)
	ver_hallway_width = int((inc_min_room_width - .5) * inc_max_room_width)
	max_room_width = inc_max_room_width
	max_room_height = inc_max_room_height
	game_width = inc_game_width
	game_height = inc_game_height
	tile_map_layer = inc_tile_map_layer
	draw_outline = inc_draw_outline
	rooms = rows * columns
