extends RigidBody2D
class_name Enemy

@export_category("Enemy Stats")
@export var stats: StatsResource# = StatsResource.new()
@export var melee_attacks: bool
@export var damage_hitbox:Area2D
@export var can_be_knockbacked:bool = true
@export var can_be_stunned:bool = true
@export var xp_on_death: int
@export var money_on_death: int
@export var weapon_knockback: float
@export var weapon_stun: float
@export var base_damage: float
@export var base_movespeed: float
@export var base_health: float
@export var base_regen: float
@export var base_knockback_modifier: float
@export var base_damage_reduction: float
@export var base_cooldown: float
@export_category("Enemy Projectile Stats")
@export var projectile: PackedScene
@export var shoots_projectiles: bool
@export var homing: bool
@export var base_range: float
@export var base_speed: float
@export var base_acceleration: float
@export var base_lifetime: float
@export var base_piercing: float
const POPUP_TEXT = preload("res://Scenes/UI/popup_text.tscn")
const xp = preload("res://Scenes/xp_blip.tscn")
var player: Player_Script
var xp_parent
var attack_on_cd: bool = true
var stun_time_left: float = 0
var stunned: bool = false
var curr_health: float
var curr_movespeed: float:
	get():
		if is_instance_valid(stats):
			return stats.get_stat(stats.MOVESPEED) + base_movespeed
		return base_movespeed
var curr_regen: float 
var curr_knockback_modifier: float:
	get():
		if is_instance_valid(stats):
			return stats.get_stat(stats.WEIGHT) + base_knockback_modifier
		return base_knockback_modifier
var curr_damage_reduction: float:
	get():
		if is_instance_valid(stats):
			return stats.get_stat(stats.STANCE) + base_damage_reduction
		return base_damage_reduction
var curr_cooldown_max: float:
	get():
		if is_instance_valid(stats):
			return base_cooldown #+ (5 / (stats.get_stat(stats.ATTACKSPEED) + 0.1)) #TODO: make this real calculation
		return base_cooldown
var cooldown_stopwatch: float = 0
## Projectile Stats:
var projectile_cooldown_stopwatch: float = 0
var curr_range: float:
	get():
		if is_instance_valid(stats):
			return stats.get_stat(stats.RANGE) + base_range
		return base_range
var curr_speed: float:
	get():
		if is_instance_valid(stats):
			return stats.get_stat(stats.VELOCITY) + base_speed
		return base_speed
var curr_acceleration: float:
	get():
		return base_acceleration
var curr_lifetime: float:
	get():
		if is_instance_valid(stats):
			return stats.get_stat(stats.DURATION) + base_lifetime
		return base_lifetime
var curr_piercing: float:
	get():
		if is_instance_valid(stats):
			return stats.get_stat(stats.PIERCING) + base_piercing
		return base_piercing

var max_health: float:
	get:
		return stats.get_stat(stats.HP) + base_health

var ImReady: bool = false

func _ready() -> void:
	call_deferred("set_stats")
	cooldown_stopwatch = 0 # make it ready to attack on start?
	add_to_group("enemy")

func set_stats():
	curr_health = stats.get_stat(stats.HP) + base_health
	curr_regen = base_regen #+ stats.get_stat(stats.REGEN)
	player = get_tree().get_first_node_in_group("player")
	xp_parent = get_tree().get_first_node_in_group("xp_parent")
	ImReady = true

func _process(delta: float) -> void:
	if !ImReady:
		return
	
	if stun_time_left > 0:
		stun_time_left -= delta
	elif stunned:
		stunned = false
	
	if cooldown_stopwatch < curr_cooldown_max:
		cooldown_stopwatch += delta
		attack_on_cd = true
	else:
		attack_on_cd = false
		if melee_attacks:
			if damage_hitbox.monitoring == false:
				damage_hitbox.set_deferred("monitoring", true) #handles the hitbox turning off for a CD after hitting the player
	
	if shoots_projectiles:
		if projectile_cooldown_stopwatch < curr_cooldown_max:
			projectile_cooldown_stopwatch += delta
			#print("cd: " + str(projectile_cooldown_stopwatch) + "/" + str(curr_cooldown_max))
		else:
			#print("range: "+ str(position.distance_to(player.position)) + "/" + str(curr_range))
			if is_player_nearby(curr_range):
				projectile_cooldown_stopwatch = 0
				print("shot projectile")
				var p: EnemyProjectile = projectile.instantiate()
				GameManager.instance.add_child(p)
				p.modulate = self.modulate
				p.global_position = global_position
				p.setup(player, self, homing, curr_speed, curr_acceleration, curr_lifetime, curr_piercing)

func _physics_process(_delta: float) -> void:
	if !ImReady:
		return
	if !stunned:
		movement_process(_delta)
	#var A = null
	#var vA = A.linear_velocity
	#var mA = A.get_mass()
	#var vB = linear_velocity
	#var mB = get_mass()
	#linear_velocity = ((mB - mA) / (mA + mB)) * vB + (2.0 * mA / (mA + mB)) * vA

	

## Overriden by extender for custom enemy movement
func movement_process(_delta: float) ->void:
	move_towards(player.global_position, _delta)
## Overriden by enemies who want different projectile vs melee damage
func damage_player_projectile(player: Node2D):
	damage_player(player)

func shoot_projectile():
	pass

func die():
	GameManager.instance.money += money_on_death
	var new_xp = xp.instantiate()
	new_xp.global_position = global_position
	xp_parent.call_deferred("add_child", new_xp)
	new_xp.set_xp(xp_on_death)
	queue_free()

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("damage") && body.is_in_group("player"):
		damage_player(body)

func damage_player(player: Node2D):
	cooldown_stopwatch = 0;
	var attack: Attack = Attack.new()
	attack.setup(attack.damage, global_position, 0, StatusEffectDictionary.new(), self, weapon_stun, 0, weapon_knockback)
	player.damage(attack)
	if melee_attacks:
		damage_hitbox.set_deferred("monitoring", false)

func move_towards(new_position: Vector2, delta:float):
	var direction: Vector2 = (new_position - global_position).normalized()
	linear_velocity = linear_velocity.move_toward(Vector2(direction.x * curr_movespeed, direction.y * curr_movespeed), 9)

func is_player_nearby(distance: float) -> bool:
	if global_position.distance_to(player.global_position) <= distance:
		return true
	return false

func damage(attack: Attack):
	var damage_taken = attack.damage - curr_damage_reduction 
	if damage_taken > 0:
		curr_health -= damage_taken
	if attack.stun > 0 && can_be_stunned:
			stun_time_left = attack.stun
			stunned = true
			linear_velocity = Vector2.ZERO
	if can_be_knockbacked && attack.knockback != 0:
		if stun_time_left < 1 && can_be_stunned:
			stun_time_left = 0.2
			stunned = true
		call_deferred("set_velocity", (global_position - attack.position).normalized() * attack.knockback * curr_knockback_modifier)
	var dmg_text: PopupText = POPUP_TEXT.instantiate()
	dmg_text.setup(str(int(round(attack.damage))), damage_taken, global_position, 1, get_tree().root, Vector2(10, 10))
	
	if curr_health <= 0:
		die()
