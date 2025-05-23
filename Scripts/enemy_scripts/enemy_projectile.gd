extends Area2D
class_name EnemyProjectile

var target: Node2D
var homing: bool
var speed: float
var acceleration: float
var parent_enemy: Node2D
var setup_bool: bool
var lifetime: float
var piercing: int

var pierce_count: int = 0
var stopwatch: float = 0
var initial_direction: Vector2
var _dead: bool = false

func setup(new_target: Node2D, new_parent_enemy: Node, new_homing: bool, new_speed: float, new_acceleration: float, new_lifetime: float, new_piercing):
	target = new_target
	parent_enemy = new_parent_enemy
	homing = new_homing
	speed = new_speed
	acceleration = new_acceleration
	lifetime = new_lifetime
	piercing = new_piercing
	initial_direction = (target.global_position - global_position).normalized()
	setup_bool = true

func _process(_delta: float):
	speed += speed * acceleration * _delta ## if speed < 0 die?
	if homing && is_instance_valid(target):
		rotation = (target.global_position - global_position).angle()
		global_position += (target.global_position - global_position).normalized() * speed * _delta
	else:
		rotation = initial_direction.angle()
		global_position += initial_direction * speed * _delta
	stopwatch += _delta
	if (stopwatch > lifetime) || (pierce_count > piercing):
		die()

func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.has_method("damage"):
		pierce_count += 1
		if is_instance_valid(parent_enemy):
			parent_enemy.damage_player_projectile(body)
		else:
			pass ## enemy already died, do nothin?

func die():
	if !_dead:
		_dead = true
		queue_free()
