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
	var player_resource: PackedScene = preload("res://Player/player.tscn")
	var player: player_2d_body = player_resource.instantiate()
	Globals.set_player(player)
	Globals.world.add_child(Globals.player)
	var player_layers: Array[int] =  [3]
	var player_masks: Array[int] = [2, 4]
	Globals.player.initialize("player", 700, player_layers, player_masks, player_2d_body.PlayerType.Player, null)
	Globals.player.set_location(Globals.generator.get_player_start())
	var enemy: player_2d_body = player_resource.instantiate()
	Globals.add_enemy(enemy)
	Globals.world.add_child(enemy)
	var enemy_layers: Array[int] = [4]
	var enemy_masks: Array[int] = [2, 3]
	Globals.enemies[0].initialize("enemy_0", 300, enemy_layers, enemy_masks, player_2d_body.PlayerType.Enemy, $EnemySpriteAnimation)
	Globals.enemies[0].set_location(Globals.generator.get_player_start())
	

func _on_floor_cleared() -> void:
	print("floor cleared message received")
