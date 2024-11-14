extends Weapon
class_name Gun
@onready var bullet =  preload("res://Scenes/bullet_1.tscn")
var bullets: Array[Area2D]

func attack():
	var new_bullet: Bullet = bullet.instantiate()
	bullets.append(new_bullet)
	new_bullet.setup(self, weapon_projectile_count, weapon_piercing, weapon_projectile_velocity, get_enemy_nearby(weapon_range + 10) - global_position)
	new_bullet.position = global_position
	get_tree().root.add_child(new_bullet)
	super()

func bullet_collision(body: Node2D) -> void:
	if (body.has_method("damage")):
		var new_attack: Attack = Attack.new()
		new_attack.damage = weapon_damage
		new_attack.knockback = weapon_knockback
		new_attack.stun_time = weapon_stun
		new_attack.position = player.global_position #TODO: decide vs using weapon's position or player's
		new_attack.damage_effect = weapon_effect
		body.damage(new_attack)
