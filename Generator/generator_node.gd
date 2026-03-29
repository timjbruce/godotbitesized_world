extends Control
class_name GeneratorNode

var generator_data: GeneratorData = null

var wall_vector: Array[Vector2i]
var floor_vector: Array[Vector2i]
var filler_vector: Array[Vector2i]
var exit_vector: Array[Vector2i]
var blocked_blocks: Array[Vector2i]
var wall_tile_quadrant_size: int = 0

var grid: Dictionary = {}
var room_listing: Dictionary = {}
var hallways: Dictionary = {}

enum TileLayer {
	Wall, Floor, Filler, Exit
}

func clear_floor() -> void:
	room_listing = {}
	generator_data.tile_map_layer.clear()


func generate() -> void:
	#create a grid that we can iterate around
	for x in range(0, generator_data.columns):
		for y in range(0,generator_data.rows):
			grid[Vector2i(x + 1, y + 1)] = {
				"x_start" : (x * (generator_data.max_room_width + generator_data.min_space_between_rooms)), 
				"y_start": (y * (generator_data.max_room_height + generator_data.min_space_between_rooms))}
	#create rooms for each location in the grid
	for location in grid:
		room_listing[location] = _generate_room(grid[location])
	#connect and draw the rooms
	_connect_rooms()
	_draw_rooms()


func initialize(inc_generator_data: GeneratorData) -> void:
	generator_data = inc_generator_data


func _ready() -> void:
	pass
	

func _get_location(room: Vector2i) -> Vector2i:
	var loc_x = randi_range(room_listing[room]["x"] + 3, room_listing[room]["x"] + room_listing[room]["width"] - 3)
	var loc_y = randi_range(room_listing[room]["y"] + 3, room_listing[room]["y"] + room_listing[room]["height"] - 3)
	print("returning ", Vector2i(loc_x, loc_y))
	return Vector2(loc_x, loc_y)


func get_player_start() -> Vector2i:
	return _get_location(Vector2i(1, 1))

		
func get_random_location() -> Vector2i:
	var room = room_listing.keys()[randi() % room_listing.size()]
	print(room)
	return _get_location(room)	


func _generate_room(grid_location) -> Dictionary:
	var room: Dictionary = {}
	room["x"] = randi_range(grid_location["x_start"], 
		grid_location["x_start"] + generator_data.min_space_between_rooms)
	room["y"] = randi_range(grid_location["y_start"], 
		grid_location["y_start"] + generator_data.min_space_between_rooms)
	room["width"] = randi_range(generator_data.min_room_width, 
		generator_data.max_room_width - (room["x"] - grid_location["x_start"]))
	room["height"] = randi_range(generator_data.min_room_height, 
		generator_data.max_room_height - (room["y"] - grid_location["y_start"]))
	return room


func _draw_rooms() -> void:
	var floors = []
	var walls = []
	var fillers = []
	if generator_data.draw_outline:
		for x in range(0, 1600):
			fillers.append(Vector2i(x,0))
		for y in range(0, 1200):
			fillers.append(Vector2i(0,y))
	for room in room_listing:
		for x in range(room_listing[room]["x"], (room_listing[room]["x"] + room_listing[room]["width"] + 1)):
			for y in range(room_listing[room]["y"], (room_listing[room]["y"] + room_listing[room]["height"] + 1)):
				if x == room_listing[room]["x"] || x == (room_listing[room]["x"] + room_listing[room]["width"]):
					if not blocked_blocks.has(Vector2i(x, y)):
						walls.append(Vector2i(x,y))
				elif y == room_listing[room]["y"] || y == (room_listing[room]["y"] + room_listing[room]["height"]):
					if not blocked_blocks.has(Vector2i(x, y)):
						walls.append(Vector2i(x,y))
				else:
					floors.append(Vector2i(x,y))
	for hall in hallways:
		for x in range(hallways[hall]["x"], (hallways[hall]["x"] + hallways[hall]["width"] + 1)):
			for y in range(hallways[hall]["y"], (hallways[hall]["y"] + hallways[hall]["height"] + 1)):
				if x == hallways[hall]["x"] || x == (hallways[hall]["x"] + hallways[hall]["width"]):
					if not blocked_blocks.has(Vector2i(x, y)):
						walls.append(Vector2i(x,y))
				elif y == hallways[hall]["y"] || y == (hallways[hall]["y"] + hallways[hall]["height"]):
					if not blocked_blocks.has(Vector2i(x, y)):
						walls.append(Vector2i(x,y))
				else:
					floors.append(Vector2i(x, y))
	exit_vector.append(get_random_location())

	floors = floors + blocked_blocks
	
	generator_data.tile_map_layer.z_index = -1
	generator_data.tile_map_layer.set_cells_terrain_connect(fillers, 0, TileLayer.Filler, false)	
	generator_data.tile_map_layer.set_cells_terrain_connect(walls, 0, TileLayer.Wall, false)
	generator_data.tile_map_layer.set_cells_terrain_connect(floors, 0, TileLayer.Floor, false)
	generator_data.tile_map_layer.set_cells_terrain_connect(exit_vector, 0, TileLayer.Exit, false)
	

func _connect_rooms():
	var left_1: int
	var right_1: int
	var top_1: int
	var bottom_1: int
	var left_2: int
	var right_2: int
	var top_2: int
	var bottom_2: int
	var left_start: int
	var right_end: int
	var top_start: int
	var bottom_end: int
	var connector: int
	var neighbor: Vector2i
	
	#location is stored as x = cols, y = rows
	for location in grid:
		if location.y < generator_data.rows:
			#need a connection down, or vertical hallway
			#find the overlap
			left_1 = room_listing[location]["x"]
			right_1 = room_listing[location]["x"] + room_listing[location]["width"]
			neighbor = Vector2i(location.x, location.y + 1)
			left_2 = room_listing[neighbor]["x"]
			right_2 = room_listing[neighbor]["x"] + room_listing[neighbor]["width"]
			if left_1 < left_2:
				left_start = left_2
			else:
				left_start = left_1
			if right_1 > right_2:
				right_end = right_2 - generator_data.ver_hallway_width
			else:
				right_end = right_1 - generator_data.ver_hallway_width
			connector = randi_range(left_start, right_end)
			for i in range(1, generator_data.ver_hallway_width):
				var value = Vector2i(connector + i, room_listing[location]["y"] + room_listing[location]["height"])
				blocked_blocks.append(value)
				value = Vector2i(connector + i, room_listing[neighbor]["y"])
				blocked_blocks.append(value)
			var height = room_listing[neighbor]["y"] - (room_listing[location]["y"] + room_listing[location]["height"])
			_add_hallway(connector, room_listing[location]["y"] + room_listing[location]["height"], generator_data.ver_hallway_width, height )
			room_listing[location]["bottom_connector_start"] = connector
			room_listing[location]["bottom_connector_end"] = connector + generator_data.ver_hallway_width
			room_listing[neighbor]["top_connector_start"] = connector
			room_listing[neighbor]["top_connector_end"] = connector + generator_data.ver_hallway_width
		if location.x < generator_data.columns:
			#need a connection to the right, or horizontal hallway
			top_1 = room_listing[location]["y"]
			bottom_1 = room_listing[location]["y"] + room_listing[location]["height"]
			neighbor = Vector2i(location.x + 1, location.y)
			top_2 = room_listing[neighbor]["y"]
			bottom_2 = room_listing[neighbor]["y"] + room_listing[neighbor]["height"]
			if top_1 < top_2:
				top_start = top_2
			else:
				top_start = top_1
			if bottom_1 > bottom_2:
				bottom_end = bottom_2 - generator_data.hor_hallway_height
			else:
				bottom_end = bottom_1 - generator_data.hor_hallway_height
			connector = randi_range(top_start, bottom_end)
			for i in range(1, generator_data.hor_hallway_height):
				var value = Vector2i(Vector2i(room_listing[location]["x"] + room_listing[location]["width"], connector + i ))
				blocked_blocks.append(value)
				value = Vector2i(room_listing[neighbor]["x"] ,connector + i )
				blocked_blocks.append(value)
			var width = room_listing[neighbor]["x"] - (room_listing[location]["x"] + room_listing[location]["width"])
			_add_hallway(room_listing[location]["x"] + room_listing[location]["width"], connector, width, generator_data.hor_hallway_height )
			room_listing[location]["right_connector_start"] = connector
			room_listing[location]["right_connector_end"] = connector + generator_data.hor_hallway_height
			room_listing[neighbor]["left_connector_start"] = connector
			room_listing[neighbor]["left_connector_end"] = connector + generator_data.hor_hallway_height


func _add_hallway(x: int, y: int, width: int, height: int) -> void:
	var hallway_len: int = len(hallways) + 1
	hallways[str(hallway_len)] = {"x": x, "y": y, "width": width, "height": height}
