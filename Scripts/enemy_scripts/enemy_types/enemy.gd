extends RigidBody2D
class_name Enemy

@export_category("Enemy Stats")
#@export var stats: StatsResource = preload("res://Resources/misc/blank_stats.tres")
@export var multiply_hp_by_minute: bool = true
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
@export var base_critchance: float = 0
@export var base_critdamage: float = 0
@export var base_movespeed: float = 20
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
const XP = preload("res://Scenes/Misc/xp_blip.tscn")
const ITEM_DROP = preload("uid://d3v2pdpqpmvpe")
@onready var FORGE_ITEM = load("uid://xn3lii5356op")

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
var curr_critchance: float
var curr_critdamage: float
## Misc:
var facing_left: bool = true
var ImReady: bool = false
var can_drop_stuff: bool = true
## Called on death with position of death
signal death(position: Vector2)
## Player Level at time Enemy was spawned
var minute: float
var level: float 
var difficulty: float 
##
var dead: bool = false
func _ready() -> void:
	flash()
	call_deferred("set_stats")
	call_deferred("setup") 
	add_to_group("enemy")
	#stats.call_deferred("setup", name)
func flash():
	visible = false
	await get_tree().create_timer(0.3).timeout
	visible = true
## called whever stats change
func set_stats():
	curr_regen = base_regen
	curr_movespeed = base_movespeed
	curr_knockback_modifier = base_knockback_modifier
	curr_damage_reduction = base_damage_reduction
	curr_cooldown_max = base_cooldown ##TODO: setup based on stats
	curr_range = base_range
	curr_speed = base_speed
	curr_acceleration = base_acceleration
	curr_lifetime = base_lifetime
	curr_piercing = base_piercing
	curr_damage = calculate_enemy_damage(base_damage, level, difficulty)
	curr_health = calculate_enemy_hp(base_health, minute + 1, difficulty, multiply_hp_by_minute)
	curr_critchance = base_critchance
	curr_critdamage = base_critdamage
##
func setup():
	player = get_tree().get_first_node_in_group("player")
	ImReady = true
	#stats.connect_changed_signal(set_stats)
## Calculate HP with given Character Level
func initialize(new_minute: float, new_level: float, new_difficulty: float):
	level = new_level
	difficulty = new_difficulty
	minute = new_minute
	#call_deferred("set_stats")
	#call_deferred("setup")
	#add_to_group("enemy")
func _process(delta: float) -> void:
	if !ImReady || dead:
		return
	
	if GameInstance.instance && global_position.distance_to(player.global_position) > GameInstance.instance.enemy_max_distance_to_player:
		GameInstance.instance.remove_enemy(self)
		dead = true
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
		else:
			if is_player_nearby(curr_range):
				projectile_cooldown_stopwatch = 0
				var proj: EnemyProjectile = projectile.instantiate()
				GameManager.instance.projectile_parent.add_child(proj)
				proj.modulate = self.modulate
				proj.global_position = global_position
				proj.setup_enemy_projectile(self)
				proj.setup_projectile(player, global_position - player.global_position, homing, 20, false, curr_piercing, curr_lifetime, curr_damage, curr_speed, 1, 1, scale.length(), curr_acceleration)
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
	if !dead:
		var game_man: GameManager = GameManager.instance
		dead = true
		death.emit(position)
		visible = false
		## Give money
		game_man.money += money_on_death
		## Drop XP
		var new_xp = XP.instantiate()
		game_man.xp_parent.add_child(new_xp)
		new_xp.global_position = global_position
		new_xp.set_xp(xp_on_death)
		if can_drop_stuff:
			## Chance to drop random component
			if randf() < GameInstance.drop_chance_component:
				drop_item()
			elif GameInstance.next_enemy_drops_component:
				drop_item()
				GameInstance.next_enemy_drops_component = false
			## Drop Forge Check
			if GameInstance.next_enemy_drops_forge:
				GameInstance.next_enemy_drops_forge = false
				drop_forge()
			## Chance to drop powerups (magnet, fire, 2x money, etc)
			if randf() < GameInstance.drop_chance_powerup:
				drop_powerup()
		queue_free()
## Drops a forge (drops when GameInstance says so)
func drop_forge():
	GameInstance.drop_item(GameInstance.FORGE_DROP.duplicate(), global_position)
## Drops a random component (enemies have a chance)
func drop_item():
	GameInstance.drop_item(ShopManager.get_rand_component(), global_position)
## Drops a chest (currenlty simple enemies don't have a chance to drop chests)
func drop_chest():
	GameInstance.drop_chest("Random Weapon!", -1, -1, -1, global_position)
## Drops a Powerup
func drop_powerup():
	GameInstance.drop_powerup(global_position)

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("damage") && body.is_in_group("player"):
		damage_player(body)
		## Handles self knockback on attack player
		if self_knockback_onhit != 0:
			apply_knockback(body.global_position, self_knockback_onhit)
func damage_player(_damage_player: Node2D):
	cooldown_stopwatch = 0;
	var attack: Attack = Attack.new(StatsResource.calculate_damage(curr_damage, curr_critchance, curr_critdamage), global_position, 0, StatusEffectDictionary.new(), self, weapon_stun, 0, weapon_knockback)
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
		GameManager.instance.EnemyDamaged.emit(self, attack)
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
	dmg_text.global_position = Vector2.ZERO
	dmg_text.setup(str(int(round(attack.damage))), damage_taken + randi_range(-5, 5), WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10))
	
	if curr_health <= 0:
		death_signal(attack)
		die()

func death_signal(attack: Attack):
	GameManager.instance.EnemyKilled.emit(self, attack)
func apply_knockback(attack_pos: Vector2, knockback: float):
	call_deferred("set_linear_velocity", (global_position - attack_pos).normalized() * knockback * curr_knockback_modifier)

static func calculate_enemy_hp(base_hp: float, hp_mult: float, game_difficulty: float, multiply_hp: bool) -> float:
	var ret: float = base_hp
	if multiply_hp:
		ret *= hp_mult
	ret *= 1 + (game_difficulty / 50)
	return ret
static func calculate_enemy_damage(base_dmg: float, game_level: float, game_difficulty: float) -> float:
	var ret: float = base_dmg
	ret *= 1 + (game_difficulty / 50)
	return ret
