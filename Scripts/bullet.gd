extends Area2D
class_name Bullet
var gun: Ranged_Weapon
var weapon_projectile_count: float 
var weapon_piercing: float
var weapon_projectile_velocity: float
var direction:Vector2

var collision_counter = 0

var stopwatch = 0.0
var lifetime = 10

func setup(base_gun:Weapon, projectile_count: float, piercing:float, velocity:float, enemy_direction:Vector2):
	gun = base_gun
	weapon_projectile_count = projectile_count
	weapon_piercing = piercing
	weapon_projectile_velocity = velocity
	direction = enemy_direction.normalized()
	rotation = direction.angle() + PI/2

func _process(delta: float) -> void:
	global_position += direction * weapon_projectile_velocity * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		queue_free()
	pass

func _on_body_entered(body: Node2D) -> void:
	gun.bullet_collision(body)
	collision_counter += 1
	if (collision_counter > weapon_piercing):
		queue_free()
