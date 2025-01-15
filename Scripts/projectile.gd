extends Area2D
class_name Projectile
var frame: Weapon_Frame
var count: float 
var piercing: float
var speed: float
var direction:Vector2

var collision_counter = 0
var stopwatch = 0.0
var lifetime = 10

@export var stats: StatsResource = StatsResource.new()

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	stats.add_stats(base_gun.stats)
	direction = enemy_direction.normalized()
	rotation = direction.angle() + PI/2
	frame = base_gun

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		die()
	pass

func _on_body_entered(body: Node2D) -> void:
	frame.hit_enemy(body)
	collision_counter += 1
	if (collision_counter > piercing):
		die()

func die():
	stats.remove_stats(frame.stats)
	queue_free()
