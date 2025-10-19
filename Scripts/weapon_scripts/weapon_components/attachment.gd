extends Area2D
class_name Attachment

const RAILGUN = preload("res://Scenes/Weapons/railgun/railgun_attachment.tscn")
const PISTOL = preload("res://Scenes/Weapons/pistol/pistol_attachment.tscn")
const FLAMETHROWER = preload("res://Scenes/Weapons/flamethrower/flamethrower_attachment.tscn")
const SWORD = preload("res://Scenes/Weapons/sword/sword_attachment.tscn")

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/pistol/pistol_attachment.tscn")

var data: ItemData = ItemData.new()

@export var stats: StatsResource# = StatsResource.new()

var bullets: Array[Projectile]
## Determines what attackspeed is, attacksperX = 2 means attackspeed is how many attacks every 2 seconds
const attacksperX: int = 1

@export var visual: AnimatedSprite2D 
@export var offset: Vector2 
@export var frame: Weapon_Frame 
@export var handle: Handle
@export var projectile: Projectile
@export var MultipleProjectileOffset: float = 2
@export var MultipleProjectileAngleOffset: float = 2
#new stuff
var cooldown_timer: float = 0
var attacking: bool = false

func _ready() -> void:
	set_stats()
	stats.parent_object_name = name
	#stats = stats.duplicate()
	cooldown_timer = 0

## meant to be overriden by extender
func setdata():
	pass#data.item_type = "attachment"

func getdata() -> ItemData:
	return data

func _process(delta: float) -> void:
	process_cooldown(delta)

## Should handle cooldown and calling attack()
## this is meant to be overridden by classes that inherit it
func process_cooldown(delta: float) -> void: 
	if attacking:
		pass
	elif cooldown_timer <= get_cooldown():
		cooldown_timer += delta
	elif handle.ready_to_fire:
		attacking = true
		attack() 

## Should handle creating a projectile, shooting it, and reseting cooldown
## this is meant to be overridden by classes that inherit it
func attack(): 
	create_projectiles()
	# Reset attack values so we can attack again
	cooldown_timer = 0
	attacking = false

func create_projectiles():
	# Create the first bullet by default
	# Randomize Direction Based on inaccuracy
	var inaccuracy: float = StatsResource.get_default(StatsResource.INACCURACY) + stats.get_stat(StatsResource.INACCURACY) 
	var direction = Vector2(cos(frame.rotation), sin(frame.rotation)).rotated(deg_to_rad(randf_range(-inaccuracy, inaccuracy)))
	init_projectile(global_position, direction)
	# Create any extra bullets using @export values to offset them by angle and position
	var proj_offset: int = 0
	for i:int in frame.get_stat(StatsResource.COUNT) + StatsResource.get_default(StatsResource.COUNT) - 1:
		if i % 2 == 0:
			proj_offset += 1
		MultipleProjectileOffset *= -1
		MultipleProjectileAngleOffset *= -1
		init_projectile(global_position + Vector2(-sin(frame.rotation), cos(frame.rotation)).normalized() * MultipleProjectileOffset * (proj_offset), Vector2(cos(frame.rotation), sin(frame.rotation)))

func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	if projectile == null:
		push_error("projectile null in attachment script")
		return null
	var new_bullet:Projectile = projectile.get_instance()
	new_bullet.visible = false
	new_bullet.setup(frame, new_direction)
	if (handle.AimType == Handle.AimTypes.Spinning): #handle aim types special cases
		frame.player.add_child(new_bullet)
	else:
		GameManager.instance.weapon_parent.add_child(new_bullet)
	new_bullet.global_position = new_position
	new_bullet.rotation = new_direction.normalized().angle()
	new_bullet.died.connect(projectile_died)
	return new_bullet

func call_def(object, method: String, arg):
	object.call_deferred(method, arg)

## to be overridden
func projectile_died(pos: Vector2, is_clone: bool):
	pass

func get_cooldown() -> float:
	return attacksperX / max(0.0001, frame.get_stat(StatsResource.ATTACKSPEED) + StatsResource.get_default(StatsResource.ATTACKSPEED)) #attackspeed is attacks per second so cd is 1/as

func make_attack() -> Attack:
	var new_attack: Attack = Attack.new()
	new_attack.setup(stats.get_stat(stats.DAMAGE), frame.player.global_position, stats.get_stat(stats.BUILDUP), StatusEffectDictionary.new(), self, 0, 0, stats.get_stat(stats.WEIGHT) * (stats.get_stat(stats.DAMAGE) / 10))
	 #TODO: determine how to calculate knockback
	return new_attack

func set_stats() -> void:
	pass # setup the stat values inside the class so they dont get reset when changing stat dictionary
