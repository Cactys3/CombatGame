extends RigidBody2D
class_name Enemy

@export_category("Enemy Stats")
@export var stats: StatsResource# = StatsResource.new()
@export var melee_attacks: bool = true
@export var damage_hitbox: Area2D
@export var can_be_knockbacked:bool = true
@export var can_be_stunned:bool = true
@export var xp_on_death: int = 10
@export var money_on_death: int = 5
@export var weapon_knockback: float = 20.0
@export var weapon_stun: float = 0
@export var self_knockback_onhit: float = 200.0
@export var base_damage: float = 10
@export var base_movespeed: float = 30
@export var base_health: float = 10
@export var base_regen: float = 0
@export var base_knockback_modifier: float = 1
@export var base_damage_reduction: float = 0
@export var base_cooldown: float = 1
@export_category("Enemy Projectile Stats")
@export var projectile: PackedScene
@export var shoots_projectiles: bool = false
@export var homing: bool = false
@export var base_range: float = 100
@export var base_speed: float = 100
@export var base_acceleration: float = 2
@export var base_lifetime: float = 15
@export var base_piercing: float = 0
@export_category("Misc")
@export var turns_towards_movement: bool = false
@export var anim: AnimatedSprite2D 
const POPUP_TEXT = preload("res://Scenes/UI/popup_text.tscn")
const xp = preload("res://Scenes/Misc/xp_blip.tscn")
var player: Character
var attack_on_cd: bool = true
var stun_time_left: float = 0
var stunned: bool = false
var curr_health: float
var curr_movespeed: float
var curr_regen: float 
var curr_knockback_modifier: float
var curr_damage_reduction: float
var curr_cooldown_max: float
var cooldown_stopwatch: float = 0
## Projectile Stats:
var projectile_cooldown_stopwatch: float = 0
var curr_range: float
var curr_speed: float
var curr_acceleration: float
var curr_lifetime: float
var curr_piercing: float
var curr_damage: float
var max_health: float
## Misc:
var facing_left: bool = true
var ImReady: bool = false
## Called on death with position of death
signal death(position: Vector2)
## Player Level at time Enemy was spawned
var level: float = 2
##
func _ready() -> void:
	call_deferred("set_stats")
	call_deferred("setup")
	cooldown_stopwatch = 0 # make it ready to attack on start?
	add_to_group("enemy")
## called whever stats change
func set_stats():
	curr_regen = base_regen + stats.get_stat_without_default(stats.REGEN)
	curr_movespeed = stats.get_stat_without_default(stats.MOVESPEED) + base_movespeed
	curr_knockback_modifier = stats.get_stat_without_default(stats.WEIGHT) + base_knockback_modifier
	curr_damage_reduction = stats.get_stat_without_default(stats.STANCE) + base_damage_reduction
	curr_cooldown_max = base_cooldown ##TODO: setup based on stats
	curr_range = stats.get_stat_without_default(stats.RANGE) + base_range
	curr_speed = stats.get_stat_without_default(stats.VELOCITY) + base_speed
	curr_acceleration = base_acceleration
	curr_lifetime = stats.get_stat_without_default(stats.DURATION) + base_lifetime
	curr_piercing = stats.get_stat_without_default(stats.PIERCING) + base_piercing
	curr_damage = stats.get_stat_without_default(stats.DAMAGE) + base_damage
	curr_health = (stats.get_stat_without_default(stats.HP) + base_health) * (1 + (level / 2)) ## TODO: level hp calculation? very high scaling of hp
##
func setup():
	player = get_tree().get_first_node_in_group("player")
	ImReady = true
	stats.set_changed_method(set_stats)
## Calculate HP with given Character Level
func initialize(new_level: float):
	level = new_level

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
				#print("shot projectile")
				var proj: EnemyProjectile = projectile.instantiate()
				GameManager.instance.projectile_parent.add_child(proj)
				proj.modulate = self.modulate
				proj.global_position = global_position
				proj.setup(player, self, homing, curr_speed, curr_acceleration, curr_lifetime, curr_piercing)

func _physics_process(_delta: float) -> void:
	if !ImReady:
		return
	if !stunned:
		movement_process(_delta)

## Overriden by extender for custom enemy movement
func movement_process(_delta: float) ->void:
	move_towards(player.global_position, curr_movespeed, _delta)
## Overriden by enemies who want different projectile vs melee damage
func damage_player_projectile(_damage_player: Node2D):
	damage_player(_damage_player)

func shoot_projectile():
	pass

func die():
	death.emit(position)
	visible = false
	GameManager.instance.money += money_on_death
	var new_xp = xp.instantiate()
	GameManager.instance.xp_parent.add_child(new_xp)
	new_xp.global_position = global_position
	new_xp.set_xp(xp_on_death)
	death_signal()
	queue_free()

func death_signal():
	GameManager.instance.EnemyKilled.emit()

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("damage") && body.is_in_group("player"):
		damage_player(body)
		## Handles self knockback on attack player
		if self_knockback_onhit != 0:
			apply_knockback(body.global_position, self_knockback_onhit)

func damage_player(_damage_player: Node2D):
	cooldown_stopwatch = 0;
	var attack: Attack = Attack.new()
	attack.setup(curr_damage, global_position, 0, StatusEffectDictionary.new(), self, weapon_stun, 0, weapon_knockback)
	_damage_player.damage(attack) #TODO: put into game manager?
	if melee_attacks:
		damage_hitbox.set_deferred("monitoring", false)

func move_towards(new_position: Vector2, movespeed: float, _delta:float):
	var direction: Vector2 = (new_position - global_position).normalized()
	linear_velocity = linear_velocity.move_toward(Vector2(direction.x * movespeed, direction.y * movespeed), 9)
	
	var new_facing_left: bool = linear_velocity.x < 0
	if anim && turns_towards_movement && facing_left != new_facing_left:
		facing_left = new_facing_left
		anim.flip_h = !facing_left

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
		apply_knockback(attack.position, attack.knockback)
		#call_deferred("set_linear_velocity", (global_position - attack.position).normalized() * attack.knockback * curr_knockback_modifier)
	var dmg_text: PopupText = POPUP_TEXT.instantiate()
	GameManager.instance.xp_parent.add_child(dmg_text)
	dmg_text.global_position = Vector2.ZERO
	dmg_text.setup(str(int(round(attack.damage))), damage_taken + randi_range(-5, 5), global_position, 1.5, Vector2(10, 10))
	
	if curr_health <= 0:
		die()

func apply_knockback(attack_pos: Vector2, knockback: float):
	call_deferred("set_linear_velocity", (global_position - attack_pos).normalized() * knockback * curr_knockback_modifier)
