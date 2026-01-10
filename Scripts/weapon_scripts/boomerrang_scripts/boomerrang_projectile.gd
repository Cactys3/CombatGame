extends Projectile

## Projectile Constantly Spins

var acceleration: float = -20
var velocity: Vector2
var basespeed: float = 3

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	super(base_gun, enemy_direction)

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func process_movement(delta: float) -> void:
	var player: Node2D = GameManager.instance.player
	direction = direction.move_toward((player.global_position - global_position).normalized(), delta * clamp(global_position.distance_to(player.global_position), 0.1, INF) / 200)
	rotate(delta * deg_to_rad(randf_range(900, 1300)))
	super(delta)
