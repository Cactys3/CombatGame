extends Area2D
class_name Attachment
#Stat Modifiers
@export var stats = {
	Weapon_Frame.damage: 0,
	Weapon_Frame.knockback: 0,
	Weapon_Frame.stun: 0,
	Weapon_Frame.effect: Attack.damage_effects.none,
	Weapon_Frame.cooldown: 0,
	Weapon_Frame.range: 0,
	Weapon_Frame.speed: 0,
	Weapon_Frame.size: 0,
	Weapon_Frame.count: 0,
	Weapon_Frame.piercing: 0,
	Weapon_Frame.duration: 0,
	Weapon_Frame.area: 0,
	Weapon_Frame.mogul: 0,
	Weapon_Frame.xp: 0,
	Weapon_Frame.lifesteal: 0,
	Weapon_Frame.movespeed: 0,
	Weapon_Frame.hp: 0,
	Weapon_Frame.handling: 0,
	}
@export var visual: AnimatedSprite2D 
@export var offset: Vector2 
@export var frame: Weapon_Frame 
@export var handle: Handle
@export var projectile: PackedScene
var ready_to_fire:bool #Tells handle if it can call Attack()
#new stuff
@export var continuous_hitbox: bool = false
var cooldown_timer: float = 0
var attacking: bool = false

func _ready() -> void:
	cooldown_timer = 0

func _process(_delta: float) -> void:
	if cooldown_timer < frame.stats[frame.cooldown]:
		cooldown_timer += _delta
	elif !attacking && frame.get_enemy_nearby(frame.stats[frame.range]) != null:
		attacking = true
		attack()

func attack(): #this is meant to be overridden by classes that inherit it
	cooldown_timer = 0
