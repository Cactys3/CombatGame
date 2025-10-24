extends Projectile

## Projectile Constantly Spins

var acceleration: float = -20
var velocity: Vector2
var basespeed: float = 3

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	super(base_gun, enemy_direction)
	velocity = direction * speed 

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func process_movement(delta: float) -> void:
	rotate(delta * deg_to_rad(randf_range(900, 1300)))
	var player: Vector2 = GameManager.instance.player.global_position
	velocity = velocity.move_toward((player - global_position).normalized() * speed, delta * player.distance_to(global_position) / 1.2)
	position += velocity * basespeed * delta
	
	#direction.move_toward((global_position - GameManager.instance.player.global_position).normalized(), delta * 2000)
	#super(delta)
