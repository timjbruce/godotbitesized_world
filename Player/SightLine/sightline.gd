extends ShapeCast2D
class_name _sightline

signal found_target(player_2d_body)
signal hit_object()

var _has_target: bool = false


func _physics_process(delta):
	# Common Block #
	
	# Per Type Block #
	match get_parent().type:
		PlayerShared.PlayerType.Player:
			return
		PlayerShared.PlayerType.Enemy:
			if is_colliding():
				var collides = get_collision_count()
				for i in collides:
					var obj = get_collider(i)
					match obj.name:
						"player":
							pass
							if not _has_target:
								_has_target = true
								found_target.emit(obj)
						"DefaultTileMap":
							if not _has_target and global_position.distance_to(collision_result[0]["point"]) < 70:
								hit_object.emit()
						_:
							if not _has_target and "enemy" in obj.name and global_position.distance_to(collision_result[0]["point"]) < 50:
								hit_object.emit()
							else:
								print("SightLine: Not looking for ", obj.name)
		PlayerShared.PlayerType.NPC:
			return
		_:
			print("_physics_process Did not have a type")
			return
	#Common Block  

func set_direction(inc_vector2: Vector2) -> void:
	rotation = inc_vector2.angle()
