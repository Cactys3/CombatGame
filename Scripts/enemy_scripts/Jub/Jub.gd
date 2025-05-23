extends Enemy

## Moves into range of player
## Shoots projectile
## Strafes in a direction (trying to stay in range of player)
@export var anim: AnimatedSprite2D

var curr_strafe_direction: Vector2 = Vector2.ZERO
var player_in_range: bool = false

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	super(_delta)

func _physics_process(_delta: float) -> void:
	super(_delta)

func movement_process(_delta: float) ->void:
	if !is_player_nearby(curr_range):
		move_towards(player.global_position, _delta)
		curr_strafe_direction = Vector2.ZERO
		anim.play("Moving")
		player_in_range = false
	else:
		player_in_range = true
		movement_strafe()

func movement_strafe():
	if curr_strafe_direction == Vector2.ZERO:
		curr_strafe_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		anim.play("Strafing")
	linear_velocity = linear_velocity.move_toward(Vector2(curr_strafe_direction.x * curr_movespeed / 2, curr_strafe_direction.y * curr_movespeed / 2), 9)


func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	pass # Doesn't do melee hitbox dmg
