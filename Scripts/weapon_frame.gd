extends Area2D
class_name Weapon_Frame

#weapon_frame fields
@onready var player: Player_Script = get_tree().get_first_node_in_group("player")
@export var weapon_slot: float = 1
@export var weapon_count: float = 1
@export var continuous_hitbox: bool = false
@export var ORBIT_DISTANCE: float = 55
@export var ROTATION_SPEED: float = 20
@export var aim_at_enemy: bool = true
var current_angle: float = 0  #Stores the angle for smooth circular motion
var cooldown_timer: float = 0
var attacking: bool = false

#components
@export var Handle: Handle
@export var Attachment: Attachment
@export var Projectile: Bullet

#stats name constants
const damage = "damage"
const knockback = "knockback"
const stun = "stun"
const effect = "effect"
const cooldown = "cooldown"
const range = "range"
const speed = "speed"
const size = "size"
const count = "count"
const piercing = "piercing"
const duration = "duration"
const area = "area"
const mogul = "mogul"
const xp = "xp"
const lifesteal = "lifesteal"
const movespeed = "movespeed"
const hp = "hp"

#stats dictionary
@export var stats = {
	#attack stats
	damage: 1,
	knockback: 1,
	stun: 1,
	effect: Attack.damage_effects,
	#other stats
	cooldown: 1,
	range: 5,
	speed: 1,
	size: 1, #when edit this, edit this: scale = Vector2(value, value)
	count: 1,
	piercing: 1,
	duration: 1,
	area: 1,
	mogul: 1,
	xp: 1,
	lifesteal: 1,
	movespeed: 1,
	hp: 100,
	}

func _ready() -> void:
	cooldown_timer = stats[cooldown] + 1

func _process(_delta: float) -> void:		
	if cooldown_timer < stats[cooldown]:
		cooldown_timer += _delta
	elif !attacking && get_enemy_nearby(stats[range]) != null:
		attacking = true
		attack()
	
	OrbitPlayer()
	var nearest_enemy = get_enemy_nearby(stats[range])
	if aim_at_enemy && nearest_enemy != null:
			RotateTowardsPosition(nearest_enemy, _delta)
	else:
		RotateTowardsPosition(get_global_mouse_position(), _delta)

func OrbitPlayer() -> void:
	var target_angle = (get_global_mouse_position() - player.global_position).normalized().angle() + (TAU * (weapon_slot/weapon_count))
	var new_position = player.global_position + Vector2(cos(target_angle), sin(target_angle)) * ORBIT_DISTANCE
	global_position = new_position

func RotateTowardsPosition(new_position: Vector2, _delta: float) -> void:
	rotation = lerp_angle(rotation, (new_position - global_position).normalized().angle() + PI / 2, ROTATION_SPEED * _delta)
 #TODO: try global_position instead of player.global_position for how weapon aiming looks

func get_enemy_nearby(distance: float) -> Variant:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			return enemy.position
	return null

func attack(): #this is meant to be overridden by classes that inherit it
	cooldown_timer = 0
	attacking = false

func hit_enemy(body:Node2D):
	if (body.has_method("damage")):
		var new_attack: Attack = Attack.new()
		new_attack.damage = stats[damage]
		new_attack.knockback = stats[knockback]
		new_attack.stun_time = stats[stun]
		new_attack.position = player.global_position #TODO: decide vs using weapon's position or player's
		new_attack.damage_effect = stats[effect]
		body.damage(new_attack)

func change_slot(slot: int, max) -> void:#Called when Weapon is created #TODO: does the weapon only need slot number to start?
	weapon_slot = slot
	weapon_count = max

func update_stats(new_cooldown: float, new_range: int, new_damage: int, new_knockback: int, new_stun: int, new_effect: Attack.damage_effects) -> void:
	stats[cooldown] = new_cooldown
	stats[range] = new_range
	stats[damage] = new_damage
	stats[knockback] = new_knockback
	stats[stun] = new_stun
	stats[effect] = new_effect
