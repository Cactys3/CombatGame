extends Node
class_name stats

#attack stats
@export var weapon_damage: int = 1
@export var weapon_knockback: float = 0
@export var weapon_stun: float = 0
@export var weapon_effect: Attack.damage_effects
#other stats
@export var weapon_cooldown: float = 1
@export var weapon_range: float = 65
@export var weapon_speed: float = 1
@export var weapon_size: float = 1 :
	set(value):
		scale = Vector2(value, value)
		weapon_size = value
