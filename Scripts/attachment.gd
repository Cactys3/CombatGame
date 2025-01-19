extends Area2D
class_name Attachment
#Stat Modifiers

@export var stats: StatsResource = StatsResource.new()

var bullets: Array[Projectile]

@export var visual: AnimatedSprite2D 
@export var offset: Vector2 
@export var frame: Weapon_Frame 
@export var handle: Handle
@export var projectile: PackedScene
#new stuff
@export var continuous_hitbox: bool = false
var cooldown_timer: float = 0
var attacking: bool = false

func _ready() -> void:
	cooldown_timer = 0

func _process(_delta: float) -> void:
	if attacking:
		pass
	elif cooldown_timer <= frame.get_stat(stats.COOLDOWN):
		cooldown_timer += _delta
		print(cooldown_timer)
	elif handle.ready_to_fire:
		attacking = true
		attack()

func attack(): #this is meant to be overridden by classes that inherit it
	#projectile = preload("res://Scenes/luger_bullet.tscn")
	#print(projectile.resource_name)
	var new_bullet:Projectile = projectile.instantiate()
	new_bullet.global_position = global_position
	new_bullet.scale = frame.scale
	new_bullet.setup(frame, Vector2(cos(frame.rotation), sin(frame.rotation)))#TODO: try this
	get_tree().root.add_child(new_bullet)
	cooldown_timer = 0
	attacking = false
