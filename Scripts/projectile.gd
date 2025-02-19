extends Area2D
class_name Projectile
var frame: Weapon_Frame
var count: float 
var piercing: float
var speed: float
var direction:Vector2

var stats: StatsResource

var collision_counter = 0
var stopwatch = 0.0
var lifetime = 10

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	stats = base_gun.stats.get_copy() #TODO: UNTESTED if this new copy is complete seperate and wont affect other listofaffections or w/e on death
	frame = base_gun
	direction = enemy_direction.normalized()
	rotation = direction.angle() 
	
	speed = (1 + frame.get_stat(StatsResource.SPEED)) * 300

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
	queue_free()
