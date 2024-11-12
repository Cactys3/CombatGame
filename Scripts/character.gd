extends CharacterBody2D

@export var SPEED: int = 210
var moving: bool = false
@export var health_component:HealthComponent

func _physics_process(_delta: float) -> void:
	handle_moving()

func handle_moving() -> void:
	var directionX := Input.get_axis("left", "right")
	if directionX:
		velocity.x = move_toward(velocity.x, directionX * SPEED, 65)#directionX * SPEED
		moving = true
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, 100)
		
	var directionY := Input.get_axis("up", "down")
	if directionY:
		velocity.y = move_toward(velocity.y, directionY * SPEED, 65)#directionY * SPEED
		moving = true
	else:
		velocity.y = move_toward(velocity.y, 0, 100)
	
	if moving:
		moving = false #TODO: walk animation
	move_and_slide()

func damage(attack: Attack):
	if (health_component):
		health_component.damage(attack)
