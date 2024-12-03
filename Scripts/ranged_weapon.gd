extends Weapon
class_name Ranged_Weapon
@onready var bullet =  preload("res://Scenes/bullet_1.tscn")
@export var MultipleProjectileOffset: float = 3
@export var MultipleProjectileAngleOffset: float = 5
@export var weapon_projectile_count: float = 1
@export var weapon_piercing: float = 1
@export var weapon_projectile_velocity: float = 300
var bullets: Array[Area2D]

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	super(_delta)

func attack():
	MultipleProjectileOffset = abs(MultipleProjectileOffset)
	MultipleProjectileAngleOffset = abs(MultipleProjectileAngleOffset)
	var target_angle = get_enemy_nearby(weapon_range + 10) - global_position
	if weapon_projectile_count < 2:
		var new_bullet: Bullet = bullet.instantiate()
		bullets.append(new_bullet)
		new_bullet.setup(self, weapon_projectile_count, weapon_piercing, weapon_projectile_velocity, target_angle)
		new_bullet.position = global_position
		new_bullet.scale = scale
		get_tree().root.add_child(new_bullet)
	else:
		for i in weapon_projectile_count:
			MultipleProjectileOffset *= -1
			MultipleProjectileAngleOffset *= -1
			var new_bullet: Bullet = bullet.instantiate()
			bullets.append(new_bullet)
			new_bullet.setup(self, weapon_projectile_count, weapon_piercing, weapon_projectile_velocity, target_angle + Vector2(-target_angle.y, target_angle.x).normalized() * MultipleProjectileAngleOffset * (i + 1))
			new_bullet.position = global_position + Vector2(-target_angle.y, target_angle.x).normalized() * MultipleProjectileOffset * (i + 1)
			new_bullet.scale = scale
			get_tree().root.add_child(new_bullet)
	super()

func bullet_collision(body: Node2D) -> void:
	hit_enemy(body)
