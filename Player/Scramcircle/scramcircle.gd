extends ShapeCast2D
class_name _scramcircle

signal scram_target(player_2d_body)
signal scram_target_clear()
signal hit_object()

var _has_target: bool = false

	
func _physics_process(delta):
	# Common Block #
	
	# Per Type Block #
	match get_parent().type:
		PlayerShared.PlayerType.Player:
			return
		PlayerShared.PlayerType.Enemy:
			return
		PlayerShared.PlayerType.NPC:
			var _scram_target: bool = false
			if is_colliding():
				var collides = get_collision_count()
				for i in collides:
					var obj = get_collider(i)
					match obj.name:
						"player":
							pass
						"DefaultTileMap":
							if not _has_target and global_position.distance_to(collision_result[0]["point"]) < 70:
								hit_object.emit()
						_:
							if not _has_target and "enemy" in obj.name and global_position.distance_to(collision_result[0]["point"]) < 100:
								scram_target.emit(obj)
								_has_target = true
								_scram_target = true
							else:
								print("ScramCircle: Not looking for ", obj.name)
			if not _scram_target and _has_target:
				_has_target = false
				scram_target_clear.emit()
		_:
			print("_physics_process Did not have a type")
			return
	#Common Block  
