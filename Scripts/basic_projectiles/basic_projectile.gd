extends Area2D
class_name BasicProjectile
## Given Variables
var target: Node2D
var homing: bool
var homing_speed: float
var is_clone: bool 
var clone_offset: float = 0.5
var size: float
var damage: float
var count: float 
var piercing: float
var buildup: float
var weight: float
var velocity: float
var direction:Vector2
var AttackedObjects: Array[Node2D] = []
var stopwatch: float = 0.0
var lifetime = 10
var acceleration: float = 0
var initial_direction: Vector2
## Self Variables
var collision_counter: float = 0
var dead: bool = false
signal died(pos: Vector2, cloned: bool)

@export var status: StatusEffects

func _ready() -> void:
	## Things flashing around screen??
	await get_tree().create_timer(0.02).timeout
	visible = true

func _process(delta: float) -> void:
	if dead:
		return
	if homing:
		process_movement_homing(delta)
	else:
		process_movement(delta)
	stopwatch += delta
	if (stopwatch > lifetime):
		die()

func process_movement(delta: float) -> void:
	position += direction * velocity * delta

func process_movement_homing(delta: float):
	## Acceleration
	velocity += velocity * acceleration * delta
	if is_instance_valid(target):
		## Homing
		move_toward(rotation, (target.global_position - global_position).angle(), delta * homing_speed)
		direction = direction.move_toward((target.global_position - global_position), delta * homing_speed)
		global_position += (direction).normalized() * velocity * delta
	else:
		## No Homing
		rotation = direction.angle()
		global_position += (direction).normalized() * velocity * delta
	## Death By Old Age
	stopwatch += delta
	if (stopwatch > lifetime) || (collision_counter > piercing):
		die()

## Setup values generic for all BasicProjectile
func setup_projectile(new_target: Node2D, enemy_direction:Vector2, is_homing: bool, new_homing_speed: float, new_is_clone: bool, new_piercing: float, new_lifetime: float, new_damage: float, new_velocity: float, new_buildup: float, new_weight: float, new_size: float, new_acceleration: float):
	size = new_size
	self.scale = Vector2(size, size) #TODO: size calculation
	target = new_target
	initial_direction = enemy_direction.normalized()
	direction = enemy_direction.normalized()
	homing = is_homing
	homing_speed = new_homing_speed
	piercing = new_piercing
	lifetime = new_lifetime
	damage = new_damage
	velocity = new_velocity
	buildup = new_buildup
	weight = new_weight
	is_clone = new_is_clone
	acceleration = new_acceleration
## Setup values specific for clones
func setup_clone(damage_offset: float):
	clone_offset = damage_offset
func _on_body_entered(body: Node2D) -> void: 
	if dead:
		return
	if body.has_method("damage") && !AttackedObjects.has(body):
		attack_body(body, is_clone)
		collision_counter += 1
		AttackedObjects.append(body)

func attack_body(body: Node2D, clone: bool) -> void:
	var new_attack = make_attack(clone)
	body.damage(new_attack)

func make_attack(clone: bool) -> Attack:
	var new_attack: Attack
	var attack_damage: float = damage
	if clone:
		attack_damage = damage * clone_offset
	if status:
		new_attack = Attack.new(attack_damage, global_position, buildup, status.AttackValues, self, 0, 0, weight * (attack_damage / 30))
	else:
		new_attack = Attack.new(attack_damage, global_position, buildup, null, self, 0, 0, weight * (attack_damage / 30))
	return new_attack

func die():
	if dead:
		return
	visible = false
	dead = true
	died.emit(global_position, is_clone)
	queue_free()
