extends Enemy

var direction: Vector2
var speed: float
var is_setup: bool = false
func setup_individual(new_direction: Vector2, new_speed: float):
	direction = new_direction
	speed = new_speed
	is_setup = true
	GameInstance.instance.enemies_spawned += 1
	GameInstance.instance.enemies_alive += 1

func die():
	super()

func movement_process(_delta: float) ->void:
	if is_setup:
		pass#position += direction * speed
