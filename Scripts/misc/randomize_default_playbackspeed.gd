extends AnimatedSprite2D
var speed: float = 1
@export var min_speed: float = 0.5
@export var max_speed: float = 1.5
func _ready() -> void:
	speed = randf_range(min_speed, max_speed)
	animation_changed.connect(set_speed)
	set_speed() 
func set_speed() -> void:
	speed_scale = speed
