extends Area2D
class_name Weapon

#weapon fields
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var weapon_slot: float
@export var weapon_count: float
@export var continuous_hitbox: bool = false
@export var ORBIT_DISTANCE: float = 55
@export var ROTATION_SPEED: float = 20
@export var aim_at_enemy: bool = true
#weapon stats
@export var cooldown: float
@export var weapon_range: float 
@export var weapon_damage: int
@export var weapon_knockback: float 
@export var weapon_stun: float 
@export var weapon_effect: Attack.damage_effects
@export var weapon_speed: float 
@export var weapon_size: float 
#melee only
@export var weapon_swing_speed: float
#ranged only
@export var weapon_projectile_count: float 
@export var weapon_piercing: float
@export var weapon_projectile_velocity: float
#field variables
var current_angle: float = 0  #Stores the angle for smooth circular motion
var cooldown_timer: float = 0
var attacking: bool = false

func _ready() -> void:
	cooldown_timer = cooldown + 1

func _process(_delta: float) -> void:
	if cooldown_timer < cooldown:
		cooldown_timer += _delta
	elif !attacking && is_enemy_nearby(weapon_range):
		attacking = true
		attack()
	
	OrbitPlayer()
	var nearest_enemy = get_enemy_nearby(weapon_range)
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
		if global_position.distance_to(enemy.global_position) <= distance:
			return enemy.position
	return null

func is_enemy_nearby(distance: float) -> bool:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= distance:
			return true
	return false

func attack(): #this is meant to be overridden by classes that inherit it
	cooldown_timer = 0
	attacking = false

func change_slot(slot: int, max) -> void:#Called when Weapon is created #TODO: does the weapon only need slot number to start?
	weapon_slot = slot
	weapon_count = max

func change_default_stats(new_cooldown: float, new_range: int, new_damage: int, new_knockback: int, new_stun: int, new_effect: Attack.damage_effects) -> void:
	cooldown = new_cooldown
	weapon_range = new_range
	weapon_damage = new_damage
	weapon_knockback = new_knockback
	weapon_stun = new_stun
	weapon_effect = new_effect
