extends Area2D
class_name Weapon

#weapon fields
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var weapon_slot: int = 0
@export var continuous_hitbox: bool = false
@export var ORBIT_DISTANCE: int = 55
@export var ROTATION_SPEED: float = 20
@export var aim_at_enemy: bool = true
#weapon stats
@export var cooldown: float
@export var weapon_range: int
@export var weapon_damage: int
@export var weapon_knockback: int
@export var weapon_stun: int
@export var weapon_effect: Attack.damage_effects

var current_angle: float = 0  #Stores the angle for smooth circular motion
var cooldown_timer: float = 0
var attacking: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	cooldown_timer = cooldown + 1
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if cooldown_timer < cooldown:
		cooldown_timer += _delta
	elif !attacking && is_enemy_nearby(weapon_range):
		attacking = true
		attack()
	
	OrbitPlayerTowardsMouse()
	if aim_at_enemy:
		var nearest_enemy = get_enemy_nearby(weapon_range)
		if nearest_enemy != null:
				RotateTowardsPosition(nearest_enemy, _delta)
		else:
			RotateTowardsPosition(get_global_mouse_position(), _delta)
	pass

func OrbitPlayerTowardsMouse() -> void:
	var target_angle = (get_global_mouse_position() - player.global_position).normalized().angle()
	var new_position = player.global_position + Vector2(cos(target_angle + (weapon_slot * (PI/2))), sin(target_angle + (weapon_slot * (PI/2)))) * ORBIT_DISTANCE
	global_position = new_position
	pass

func RotateTowardsPosition(new_position: Vector2, _delta: float) -> void:
	rotation = lerp_angle(rotation, (new_position - global_position).normalized().angle() + PI / 2, ROTATION_SPEED * _delta)
 #TODO: try global_position instead of player.global_position for how weapon aiming looks

func get_enemy_nearby(distance: float) -> Variant:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if position.distance_to(enemy.position) <= distance:
			return enemy.position
	return null

func is_enemy_nearby(distance: float) -> bool:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if position.distance_to(enemy.position) <= distance:
			return true
	return false

func attack(): #this is meant to be overridden by classes that inherit it
	cooldown_timer = 0
