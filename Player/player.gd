extends CharacterBody2D
class_name player_2d_body

@export var speed: int = 600
@export var type: PlayerShared.PlayerType = PlayerShared.PlayerType.Player 
@export var animation: AnimatedSprite2D = null

var _x_direction: float = 0.0
var _y_direction: float = 0.0

var _sight_line: _sightline = null
var _target: player_2d_body = null

var _scram_circle: _scramcircle = null
var _target_cleared: bool = false


func _ready() -> void:
	if get_parent().name == "root":
		initialize("Tim", 500, [3], [2], PlayerShared.PlayerType.Player, null)


func initialize(inc_name: String, inc_speed: int, inc_layers: Array[int], inc_mask: Array[int], 
	# Common Block #
	inc_type: PlayerShared.PlayerType, inc_animation: AnimatedSprite2D = null) -> void:
		name = inc_name
		speed = inc_speed
		type = inc_type
		if inc_animation:
			$AnimatedSprite2D.sprite_frames = inc_animation.sprite_frames
		for layer in inc_layers:
			set_collision_layer_value(layer, true)
		for mask in inc_mask:
			set_collision_mask_value(mask, true)
		
	# Per Type Block #
		match type:
			PlayerShared.PlayerType.Player:
				$PlayerTypeLabel.text = "Player"
				$Camera2D.enabled = true
			PlayerShared.PlayerType.Enemy:
				$PlayerTypeLabel.text = "Enemy"
				$Camera2D.enabled = false
				_sight_line = preload("res://Player/Sightline/Sightline.tscn").instantiate()
				for mask in inc_mask:
					_sight_line.set_collision_mask_value(mask, true)
				add_child(_sight_line)
				_sight_line.found_target.connect(_on_found_target)
				_sight_line.hit_object.connect(_on_hit_object)
			PlayerShared.PlayerType.NPC:
				$PlayerTypeLabel.text = "NPC"
				$Camera2D.enabled = false
				_scram_circle = preload("res://Player/Scramcircle/Scramcircle.tscn").instantiate()
				for mask in inc_mask:
					_scram_circle.set_collision_mask_value(mask, true)
				add_child(_scram_circle)
				_scram_circle.hit_object.connect(_on_hit_object)
				_scram_circle.scram_target.connect(_on_scram_target)
				_scram_circle.scram_target_clear.connect(_on_clear_scram_target)
			_:
				print("initialize Did not have a type")
				$Camera2D.enabled = false
		
	# Common Block #


func set_location(new_location: Vector2i) -> void:
	global_position = new_location	


func _process(_delta: float) -> void:
	# Common Block #
	
	# Per Type Block #
	match type:
		PlayerShared.PlayerType.Player:
			_x_direction = Input.get_axis("left", "right")
			_y_direction = Input.get_axis("up", "down")		
			if _x_direction:
				velocity.x = _x_direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
			if _y_direction:
				velocity.y = _y_direction * speed
			else:
				velocity.y = move_toward(velocity.y, 0, speed)
		PlayerShared.PlayerType.Enemy:
			if _target:
				var cur_vector: Vector2 = (_target.position - global_position).normalized()
				velocity = cur_vector * speed
				_sight_line.set_direction(cur_vector)
			else:
				if velocity == Vector2.ZERO:
					var rand_vector: Vector2 = _random_vector()
					velocity = rand_vector * (speed / 2.0)
					_sight_line.set_direction(rand_vector)
		PlayerShared.PlayerType.NPC:
			if _target:
				var cur_vector: Vector2 = (_target.position - global_position).normalized().rotated(180)
				velocity = cur_vector * speed * 2
			else:
				if velocity == Vector2.ZERO:
					var rand_vector: Vector2 = _random_vector()
					velocity = rand_vector * (speed)
				elif _target_cleared:
					_target_cleared = false
					var rand_vector: Vector2 = _random_vector()
					velocity = rand_vector * (speed)
		_:
			print("_process did not have a type ")
		
	# Common Block
	if velocity.x != 0 and abs(velocity.x) > abs(velocity.y):
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "up"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "down"
	else:
		$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	
	move_and_slide()
	
func _on_found_target(inc_target: player_2d_body) -> void:
	_target = inc_target


func _on_scram_target(inc_target: player_2d_body) -> void:
	_target = inc_target


func _on_clear_scram_target() -> void:
	_target_cleared = true
	_target = null

	
func _on_hit_object() -> void:
	velocity = Vector2.ZERO


func _random_vector() -> Vector2:
	#check up, down, left, and right - limit the vector to good locations
	var raycast: RayCast2D = RayCast2D.new()
	var x_min: float = -1.0
	var x_max: float = 1.0
	var y_min: float = -1.0
	var y_max: float = 1.0
	raycast.set_collision_mask_value(2, true)
	raycast.target_position = Vector2i.RIGHT * 50
	if raycast.is_colliding():
		x_max = 0.25
	raycast.target_position = Vector2i.LEFT * 50
	if raycast.is_colliding():
		x_min = -0.25
	raycast.target_position = Vector2i.UP * 50
	if raycast.is_colliding():
		y_max = 0.25
	raycast.target_position = Vector2i.DOWN * 50
	if raycast.is_colliding():
		y_min = -0.25
	raycast.free()
	return Vector2(randf_range(x_min, x_max), randf_range(y_min, y_max))
