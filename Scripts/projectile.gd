extends Area2D
class_name Projectile
var weapon: Weapon_Frame
var count: float 
var piercing: float
var speed: float
var direction:Vector2

var collision_counter = 0
var stopwatch = 0.0
var lifetime = 10

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	weapon = base_gun
	count = weapon.stats[weapon.count]
	piercing = weapon.stats[weapon.piercing]
	speed = weapon.stats[weapon.speed]
	direction = enemy_direction.normalized()
	rotation = direction.angle() + PI/2

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		queue_free()
	pass

func _on_body_entered(body: Node2D) -> void:
	weapon.hit_enemy(body)
	collision_counter += 1
	if (collision_counter > piercing):
		queue_free()
