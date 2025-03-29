extends Area2D
class_name Projectile
var frame: Weapon_Frame
var count: float 
var piercing: float
var speed: float
var direction:Vector2

var stats: StatsResource = StatsResource.new()
var status: Attack = Attack.new()

var AttackedObjects: Array[Node2D] = []

var collision_counter = 0
var stopwatch = 0.0
var lifetime = 10

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	stats = base_gun.stats.get_copy()
	frame = base_gun
	direction = enemy_direction.normalized()
	rotation = direction.angle() 
	var size_value = stats.get_stat(StatsResource.SIZE)
	self.scale = Vector2(size_value, size_value)
	status = status.duplicate()
	
	lifetime = frame.get_stat(StatsResource.DURATION)
	
	speed = (1 + frame.get_stat(StatsResource.VELOCITY)) * 13


func _process(delta: float) -> void: #TODO: testing pyhsics_process vs process (and queued attacks)
	position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		die()

## this can be overriden by polymorph (what's it called?) to do unique attacks
func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		body.damage(new_attack)
		collision_counter += 1
		AttackedObjects.append(body)
		if (collision_counter > piercing):
			die() 

func _on_body_entered(body: Node2D) -> void: #TODO: testing this queueAttacks things because deepseek said accessing my stats like this could corrupt because physics vs main thread multithreading...
	if body.has_method("damage"):
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self))

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
