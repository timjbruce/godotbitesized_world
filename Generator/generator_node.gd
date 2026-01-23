extends Control
class_name GeneratorNode

var min_room_width: int = 3
var min_room_height: int = 3
var max_room_width: int = 500
var max_room_height: int = 500
var game_width: int = 1600
var game_height: int = 1200
var tile_map_layer: TileMapLayer = null
var draw_outline: bool = false

var wall_vector: Vector2i
var floor_vector: Vector2i
var filler_vector: Vector2i
var exit_vector: Vector2i
var wall_tile_quadrant_size: int = 0

var room_listing: Dictionary


func clear_floor() -> void:
	room_listing = {}
	tile_map_layer.clear()


func generate() -> void:
	var grid: Dictionary = {Vector2i(0,0): {"x_start": 0, "y_start": 0}}
	room_listing = _generate_room(grid)
	_draw_rooms()


func initialize(inc_min_room_width: int, inc_min_room_height: int, inc_max_room_width: int, inc_max_room_height: int,
				inc_game_width: int, inc_game_height: int, inc_tile_map_layer: TileMapLayer, inc_draw_outline: bool) -> void:
	min_room_width = inc_min_room_width
	min_room_height = inc_min_room_height
	max_room_width = inc_max_room_width
	max_room_height = inc_max_room_height
	game_width = inc_game_width
	game_height = inc_game_height
	tile_map_layer = inc_tile_map_layer
	draw_outline = inc_draw_outline
	_get_main_tiles()

func _ready() -> void:
	pass
	
	
func _get_main_tiles() -> void:
	var terrains = {}
	wall_tile_quadrant_size = tile_map_layer.rendering_quadrant_size
	for terrain in tile_map_layer.tile_set.get_terrains_count(0):
		terrains[str(terrain)] = tile_map_layer.tile_set.get_terrain_name(0,terrain)
	var source = tile_map_layer.tile_set.get_source(0)
	#check every tile to find its terrain
	for tile in source.get_tiles_count():
		var tile_data = source.get_tile_data(source.get_tile_id(tile), 0)
		if tile_data.terrain != -1:
			match terrains[str(tile_data.terrain)]:
				"Wall":
					wall_vector = source.get_tile_id(tile)
				"Floor":
					floor_vector = source.get_tile_id(tile)
				"Filler":
					filler_vector = source.get_tile_id(tile)
				"Exit":
					exit_vector = source.get_tile_id(tile)
	

func get_player_start() -> Vector2i:
	var start_location: Vector2i
	start_location = Vector2i(randi_range(room_listing["y"] + wall_tile_quadrant_size, (room_listing["width"] - 1) * wall_tile_quadrant_size),
		randi_range(room_listing["x"] + wall_tile_quadrant_size, (room_listing["height"] - 1) * wall_tile_quadrant_size ))
	return start_location


func _generate_room(grid_location) -> Dictionary:
	var room: Dictionary = {}
	for item in grid_location:
		room["x"] = randi_range(grid_location[item]["x_start"], 
			grid_location[item]["x_start"])
		room["y"] = randi_range(grid_location[item]["y_start"], 
			grid_location[item]["y_start"])
		room["width"] = randi_range(min_room_width, max_room_width - (room["x"] - grid_location[item]["x_start"]))
		room["height"] = randi_range(min_room_height, max_room_height - (room["y"] - grid_location[item]["y_start"]))
	return room


func _draw_rooms() -> void:
	if draw_outline:
		for x in range(0, game_width):
			if x % 25 == 0:
				tile_map_layer.set_cell(Vector2i(x,0), 0, floor_vector)
			else:
				tile_map_layer.set_cell(Vector2i(x,0), 0, filler_vector)
		for y in range(0, game_height):
			if y % 25 == 0:
				tile_map_layer.set_cell(Vector2i(0,y), 0, floor_vector)
			else:
				tile_map_layer.set_cell(Vector2i(0,y), 0, filler_vector)

	for x in range(room_listing["x"], (room_listing["x"] + room_listing["width"] + 1)):
		for y in range(room_listing["y"], (room_listing["y"] + room_listing["height"] + 1)):
			if x == room_listing["x"] || x == (room_listing["x"] + room_listing["width"]):
				tile_map_layer.set_cell(Vector2i(x,y), 0, wall_vector)
			elif y == room_listing["y"] || y == (room_listing["y"] + room_listing["height"]):
				tile_map_layer.set_cell(Vector2i(x,y), 0, wall_vector)
			else:
				tile_map_layer.set_cell(Vector2i(x,y), 0, floor_vector)
