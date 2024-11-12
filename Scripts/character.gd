extends CharacterBody2D

@export var SPEED: int = 300
var moving: bool = false
@export var health_component:HealthComponent

func _physics_process(_delta: float) -> void:
	handle_moving()

func handle_moving() -> void:
	var directionX := Input.get_axis("left", "right")
	if directionX:
		velocity.x = directionX * SPEED
		moving = true
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var directionY := Input.get_axis("up", "down")
	if directionY:
		velocity.y = directionY * SPEED
		moving = true
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if moving:
		moving = false #TODO: walk animation
	move_and_slide()

func damage(attack: Attack):
	if (health_component):
		health_component.damage(attack)
