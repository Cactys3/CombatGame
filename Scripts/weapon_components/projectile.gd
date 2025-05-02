extends Area2D
class_name Projectile

const FLAMETHROWER = preload("res://Scenes/flamethrower/fire_projectile.tscn")
const PISTOL = preload("res://Scenes/pistol/pistol_bullet.tscn")
const RAILGUN = preload("res://Scenes/railgun/railgun_projectile.tscn")
const SWORD = preload("res://Scenes/sword/sword_projectile.tscn")


func get_instance():
	const type = preload("res://Scripts/flamethrower_scripts/fire_projectile.gd")
	var ret: type = preload("res://Scenes/flamethrower/fire_projectile.tscn").instantiate()
	add_child(ret)
	ret.status = ret.status.duplicate()
	ret.stats = ret.stats.duplicate()
	ret.my_stats = ret.my_stats.duplicate()
	remove_child(ret)
	if !(ret.status.attack_bleed + ret.stats.get_stat(stats.ATTACKSPEED) + ret.my_stats.get_stat(stats.ATTACKSPEED)) || !ret.status.attack_bleed || !ret.stats || !ret.my_stats:
		print("Determined that I need this print statment or the runtime will not load the @export variables from any custom resources. Must do something to Custom Resources before returning instance for all Projectiles (maybe other components too)" + str(ret.status.attack_bleed))
	return ret


var data: ItemData = ItemData.new()

var frame: Weapon_Frame
var count: float 
var piercing: float
var speed: float
var direction:Vector2

## Currently set to weapon_frame's stats
var stats: StatsResource = StatsResource.new()
## In the future, maybe used to set Projectile specific stats
@export var my_stats: StatsResource = StatsResource.new()
## Not decided, holds attack, defense, current values
@export var status: StatusEffects = StatusEffects.new()
@export var p: NodePath
@export var tree: int
var AttackedObjects: Array[Node2D] = []

var collision_counter = 0
var stopwatch = 0.0
var lifetime = 10


func init():
	pass

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	stats.parent_object_name = name
	stats = base_gun.stats.get_copy()
	
	frame = base_gun
	direction = enemy_direction.normalized()
	rotation = direction.angle() 
	var size_value = stats.get_stat(StatsResource.SIZE)
	self.scale = Vector2(size_value, size_value)
	
	lifetime = frame.get_stat(StatsResource.DURATION)
	
	speed = (1 + frame.get_stat(StatsResource.VELOCITY)) * 13
	
	setdata()

## meant to be overriden by extender
func setdata():
	data.item_type = "projectile"

func getdata() -> ItemData:
	return data

func _process(delta: float) -> void: #TODO: testing pyhsics_process vs process (and queued attacks)
	position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		die()

## this can be overriden by polymorph (what's it called?) to do unique attacks
func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		body.damage(new_attack)
		collision_counter += 1
		AttackedObjects.append(body)
		if (collision_counter > piercing):
			die() 

func _on_body_entered(body: Node2D) -> void: #TODO: testing this queueAttacks things because deepseek said accessing my stats like this could corrupt because physics vs main thread multithreading...
	if body.has_method("damage"):
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self))

func make_attack() -> Attack:
	var new_attack: Attack = Attack.new()
	new_attack.damage = stats.get_stat(stats.DAMAGE)
	new_attack.knockback = stats.get_stat(stats.WEIGHT) * (stats.get_stat(stats.DAMAGE) / 30) #TODO: determine how to calculate knockback
	new_attack.position = frame.player.global_position
	new_attack.burning = status.attack_burning
	new_attack.frost = status.attack_frost
	new_attack.poison = status.attack_poison
	new_attack.bleed = status.attack_bleed
	new_attack.shock = status.attack_shock
	new_attack.wet = status.attack_wet
	print("Sending New Attack From: " + name)
	print("Burning: " + str(status.attack_burning))
	return new_attack

func die():
	queue_free()
