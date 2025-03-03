extends Area2D
class_name Projectile
var frame: Weapon_Frame
var count: float 
var piercing: float
var speed: float
var direction:Vector2

var stats: StatsResource = StatsResource.new()
var status: Attack = Attack.new()


var collision_counter = 0
var stopwatch = 0.0
var lifetime = 10

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	stats = base_gun.stats.get_copy() #TODO: UNTESTED if this new copy is complete seperate and wont affect other listofaffections or w/e on death
	frame = base_gun
	direction = enemy_direction.normalized()
	rotation = direction.angle() 
	self.scale = Vector2(stats.get_stat(StatsResource.SIZE), stats.get_stat(StatsResource.SIZE))
	status = status.duplicate()
	
	lifetime = frame.get_stat(StatsResource.DURATION)
	
	speed = (1 + frame.get_stat(StatsResource.VELOCITY)) * 13

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		die()

func _on_body_entered(body: Node2D) -> void:
	var new_attack = make_attack()
	if frame.hit_enemy(body, new_attack): #returns if target has damage() method
		collision_counter += 1
		if (collision_counter > piercing):
			die()

func make_attack() -> Attack:
	var new_attack: Attack = Attack.new()
	new_attack.damage = stats.get_stat(stats.DAMAGE)
	new_attack.knockback = stats.get_stat(stats.WEIGHT) * (stats.get_stat(stats.DAMAGE) / 30) #TODO: determine how to calculate knockback
	new_attack.position = frame.player.global_position
	new_attack.bleed = status.bleed
	new_attack.burn = status.burn
	new_attack.toxic = status.toxic
	new_attack.slow = status.slow
	new_attack.stun = status.stun
	new_attack.rage = status.rage
	return new_attack

func die():
	queue_free()
