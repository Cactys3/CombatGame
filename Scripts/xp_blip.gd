extends RigidBody2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var acceleration: float = 1
var speed: float = 0
var xp_value: int = 1
var is_collected: bool = false
var timer = 0

func _ready() -> void:
	#set sprite hue based on xp_value
	pass 


func _process(delta: float) -> void: #TODO: rework acceleration/speed to be based off player speed and be exponential acceleration curve
	if is_collected:
		#print(speed)
		timer += delta
		acceleration = 50
		if (speed < 1000):
			speed += delta * acceleration  # Increment speed
		#linear_velocity = (player.global_position - global_position).normalized() * speed * delta
		#linear_velocity = (player.global_position - global_position).normalized() * linear_velocity.length()
		#apply_force((player.global_position - global_position).normalized() * acceleration, Vector2.ZERO)
		
		if (timer > 0.1):#does the little jump, didn't turn out how i want exactly (yet..?)
			position = position + ((-position + player.position).normalized() * delta * speed)
	pass

func _entered(area: Area2D) -> void: #area2d
	if area.is_in_group("xp_range") && !is_collected:
		linear_velocity = (global_position - player.global_position).normalized() * 300
		is_collected = true
		animation.pause()
		speed = 200
		acceleration = 50
	pass # Replace with function body.

func _entered_body(body: Node2D) -> void:
	#print("body")
	if body.is_in_group("player"):
		player.current_xp += xp_value
		queue_free()
	pass # Replace with function body.
