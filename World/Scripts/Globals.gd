extends Node

var world: Node2D
var player: player_2d_body
var global_timer: Timer
var generator: Generator

func set_world(inc_world: Node2D) -> void:
	world = inc_world
	
func set_player(inc_player: player_2d_body) -> void:
	player = inc_player
	
func set_global_timer(inc_timer: Timer) -> void:
	global_timer = inc_timer

func set_generator(inc_generator: Generator) -> void:
	generator = inc_generator
