extends Node2D

func _ready() -> void:
	Globals.set_world($".")
	Globals.set_global_timer($GlobalTimer)
	Globals.set_generator($Generator)
	Globals.generator.floor_generated.connect(_on_floor_generated)
	Globals.generator.floor_is_cleared.connect(_on_floor_cleared)
	Globals.generator.generate()

func _on_floor_generated() -> void:
	print("floor generated message received")
	var player_resource: Node2D = preload("res://Player/player.tscn").instantiate()
	Globals.set_player(player_resource)
	Globals.world.add_child(Globals.player)
	Globals.player.initialize("player", 600, [], [2])
	Globals.player.set_location(Globals.generator.get_player_start())
	

func _on_floor_cleared() -> void:
	print("floor cleared message received")
