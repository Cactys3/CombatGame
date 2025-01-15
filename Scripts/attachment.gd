extends Area2D
class_name Attachment
#Stat Modifiers

@export var stats: StatsResource = StatsResource.new()

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
	if cooldown_timer < frame.get_stat(stats.COOLDOWN):
		cooldown_timer += _delta
	elif !attacking && frame.get_enemy_nearby(frame.get_stat(stats.RANGE)) != null:
		attacking = true
		attack()

func attack(): #this is meant to be overridden by classes that inherit it
	cooldown_timer = 0
