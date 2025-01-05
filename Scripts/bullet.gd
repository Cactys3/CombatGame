extends Area2D
class_name Bullet
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
	}

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
