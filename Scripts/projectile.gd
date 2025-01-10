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

#Stat Modifiers
@export var stats = {
	Weapon_Frame.damage: 0,
	Weapon_Frame.knockback: 0,
	Weapon_Frame.stun: 0,
	Weapon_Frame.effect: Attack.damage_effects.none,
	Weapon_Frame.cooldown: 0,
	Weapon_Frame.range: 0,
	Weapon_Frame.speed: 0,
	Weapon_Frame.size: 0,
	Weapon_Frame.count: 0,
	Weapon_Frame.piercing: 0,
	Weapon_Frame.duration: 0,
	Weapon_Frame.area: 0,
	Weapon_Frame.mogul: 0,
	Weapon_Frame.xp: 0,
	Weapon_Frame.lifesteal: 0,
	Weapon_Frame.movespeed: 0,
	Weapon_Frame.hp: 0,
	Weapon_Frame.handling: 0,
	}

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	frame = base_gun
	count = frame.stats[frame.count]
	piercing = frame.stats[frame.piercing]
	speed = frame.stats[frame.speed]
	direction = enemy_direction.normalized()
	rotation = direction.angle() + PI/2

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		queue_free()
	pass

func _on_body_entered(body: Node2D) -> void:
	frame.hit_enemy(body)
	collision_counter += 1
	if (collision_counter > piercing):
		queue_free()
