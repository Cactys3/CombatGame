extends Area2D
class_name Projectile

#const FLAMETHROWER = preload("res://Resources/Weapons/Flamethrower/flamethrower_projectile.tres")

const FLAMETHROWER = preload("res://Scenes/Weapons/flamethrower/fire_projectile.tscn")
const PISTOL = preload("res://Scenes/Weapons/pistol/pistol_bullet.tscn")
const RAILGUN = preload("res://Scenes/Weapons/railgun/railgun_projectile.tscn")
const SWORD = preload("res://Scenes/Weapons/sword/sword_projectile.tscn")
func get_instance():
	#const type = preload("res://Scripts/weapon_scripts/flamethrower_scripts/fire_projectile.gd")
	#var ret: type = preload("res://Scenes/Weapons/flamethrower/fire_projectile.tscn").instantiate()
	var ret: Projectile = data.get_item()
	return ret

## TODO: Acceleration? Positive and Negative

## In the future, maybe used to set Projectile specific stats
@export var stats: StatsResource #= StatsResource.new()
## Not decided, holds attack, defense, current values
#@export var status: StatusEffects = StatusEffects.new()
@export var status: StatusEffects #= StatusEffectDictionary.new()

## Is this projectile somehow not original/from gun
var is_clone: bool = false

var data: ItemData = ItemData.new()
var frame: Weapon_Frame
var damage: float
var count: float 
var piercing: float
var buildup: float
var weight: float
var speed: float
var direction:Vector2
var frame_stats: StatsResource
var AttackedObjects: Array[Node2D] = []
var collision_counter: float = 0
var stopwatch: float = 0.0
var lifetime = 10

var dead: bool = false
signal died(pos: Vector2, cloned: bool)

func _ready():
	## TODO: fix the issue where bullets flash around the screen when created
	await get_tree().create_timer(0.02).timeout
	visible = true

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	frame_stats = base_gun.stats.get_copy() # get copy incase gun is freed
	frame_stats.parent_object_name = name
	frame = base_gun
	var size_value = frame_stats.get_stat(StatsResource.SIZE) + StatsResource.get_default(StatsResource.SIZE)
	self.scale = Vector2(size_value, size_value)
	direction = enemy_direction.normalized()
	piercing = frame_stats.get_stat(StatsResource.PIERCING) + StatsResource.get_default(StatsResource.PIERCING)
	lifetime = frame.get_stat(StatsResource.DURATION) + StatsResource.get_default(StatsResource.DURATION)
	damage = frame_stats.get_stat(frame_stats.DAMAGE) + StatsResource.get_default(StatsResource.DAMAGE)
	speed = (frame.get_stat(StatsResource.VELOCITY) + StatsResource.get_default(StatsResource.VELOCITY)) * 13
	buildup = frame_stats.get_stat(frame_stats.BUILDUP) + StatsResource.get_default(StatsResource.BUILDUP)
	weight = (frame_stats.get_stat(frame_stats.WEIGHT) + StatsResource.get_default(StatsResource.WEIGHT))
	setdata()


## meant to be overriden by extender
func setdata():
	pass#data.item_type = "projectile"

func getdata() -> ItemData:
	return data

func _process(delta: float) -> void: #TODO: testing pyhsics_process vs process (and queued attacks)
	if dead:
		return
	process_movement(delta)
	stopwatch += delta
	if (stopwatch > lifetime):
		die()

func process_movement(delta: float) -> void:
	position += direction * speed * delta

## this can be overriden by polymorph (what's it called?) to do unique attacks
func attack_body(body: Node2D) -> void:
	if dead:
		return
	
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		body.damage(new_attack)
		collision_counter += 1
		AttackedObjects.append(body)
		if (collision_counter > piercing):
			die() 

func _on_body_entered(body: Node2D) -> void: #TODO: testing this queueAttacks things because deepseek said accessing my stats like this could corrupt because physics vs main thread multithreading...
	if dead:
		return
	if body.has_method("damage"):
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self))

func make_attack() -> Attack:
	var new_attack: Attack = Attack.new()
	new_attack.setup(damage, global_position, buildup, status.AttackValues, self, 0, 0, weight * (damage / 30))
	return new_attack

func die():
	visible = false
	dead = true
	died.emit(global_position, is_clone)
	queue_free()

## Overriden
static func get_level_upgrades(itemdata: ItemData) -> Array[LevelUpgrade]:
	var arr: Array[LevelUpgrade]
	var u1: LevelUpgrade = LevelUpgrade.new()
	u1.setup(StatsResource.DAMAGE, false, randf_range(15, 30))
	arr.append(u1)
	return arr
