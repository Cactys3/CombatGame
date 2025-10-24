extends Projectile

var acceleration: float = -20
var velocity: Vector2

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	super(base_gun, enemy_direction)
	velocity = direction * speed 

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func process_movement(delta: float) -> void:
	rotate(delta * deg_to_rad(1))
	var player: Vector2 = GameManager.instance.player.global_position
	velocity = velocity.move_toward((player - global_position).normalized() * speed, delta * player.distance_to(global_position) * 1.5)
	position += velocity * delta
	
	#direction.move_toward((global_position - GameManager.instance.player.global_position).normalized(), delta * 2000)
	#super(delta)
