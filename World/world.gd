extends Node2D

func _ready() -> void:
	Globals.set_world($".")
	Globals.set_player($Player)
	Globals.set_global_timer($GlobalTimer)
