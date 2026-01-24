extends CharacterBody2D
class_name player_2d_body

enum PlayerType { Player, Enemy, NPC }

@export var speed: int = 600
@export var type: PlayerType = PlayerType.Player 
@export var animation: AnimatedSprite2D = null

var _x_direction: float = 0.0
var _y_direction: float = 0.0


func _ready() -> void:
	if get_parent().name == "root":
		initialize("Tim", 500, [3], [2], PlayerType.Player, null)


func initialize(inc_name: String, inc_speed: int, inc_layers: Array[int], inc_mask: Array[int], 
	inc_type: PlayerType, inc_animation: AnimatedSprite2D = null) -> void:
		name = inc_name
		speed = inc_speed
		type = inc_type
		match type:
			PlayerType.Player:
				$PlayerTypeLabel.text = "Player"
			PlayerType.Enemy:
				$PlayerTypeLabel.text = "Enemy"
			PlayerType.NPC:
				$PlayerTypeLabel.text = "NPC"
			_:
				"!!!!!!!"
		if inc_animation:
			$AnimatedSprite2D.sprite_frames = inc_animation.sprite_frames
		for layer in inc_layers:
			set_collision_layer_value(layer, true)
		for mask in inc_mask:
			set_collision_mask_value(mask, true)


func set_location(new_location: Vector2i) -> void:
	global_position = new_location	


func _process(_delta: float) -> void:
	if type == PlayerType.Player:
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
