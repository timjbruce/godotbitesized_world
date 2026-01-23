extends CharacterBody2D
class_name player_2d_body

@export var speed: int = 600


func initialize(inc_name: String, inc_speed: int, inc_layers: Array[int], inc_mask: Array[int]) -> void:
	name = inc_name
	speed = inc_speed
	for layer in inc_layers:
		set_collision_layer_value(layer, true)
	for mask in inc_mask:
		set_collision_mask_value(mask, true)


func set_location(new_location: Vector2i) -> void:
	global_position = new_location	


func _process(_delta: float) -> void:
	var x_direction: float = Input.get_axis("left", "right")
	var y_direction: float = Input.get_axis("up", "down")
	if x_direction:
		velocity.x = x_direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if y_direction:
		velocity.y = y_direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
		
	if velocity.x != 0:
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
