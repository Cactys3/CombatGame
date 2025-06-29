extends Area2D
class_name Projectile
const FLAMETHROWER = preload("res://Scenes/Weapons/flamethrower/fire_projectile.tscn")
const PISTOL = preload("res://Scenes/Weapons/pistol/pistol_bullet.tscn")
const RAILGUN = preload("res://Scenes/Weapons/railgun/railgun_projectile.tscn")
const SWORD = preload("res://Scenes/Weapons/sword/sword_projectile.tscn")
func get_instance():
	const type = preload("res://Scripts/flamethrower_scripts/fire_projectile.gd")
	var ret: type = preload("res://Scenes/Weapons/flamethrower/fire_projectile.tscn").instantiate()
	add_child(ret)
	ret.status = ret.status.duplicate()
	ret.stats = ret.stats.duplicate()
	remove_child(ret)
	return ret

## TODO: Acceleration? Positive and Negative

## In the future, maybe used to set Projectile specific stats
@export var stats: StatsResource #= StatsResource.new()
## Not decided, holds attack, defense, current values
#@export var status: StatusEffects = StatusEffects.new()
@export var status: StatusEffectDictionary #= StatusEffectDictionary.new()

var data: ItemData = ItemData.new()
var frame: Weapon_Frame
var count: float 
var piercing: float
var speed: float
var direction:Vector2
var frame_stats: StatsResource
var AttackedObjects: Array[Node2D] = []
var collision_counter = 0
var stopwatch = 0.0
var lifetime = 10

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	frame_stats = base_gun.stats.get_copy() # get copy incase gun is freed
	frame_stats.parent_object_name = name
	frame = base_gun
	direction = enemy_direction.normalized()
	rotation = direction.angle() 
	var size_value = frame_stats.get_stat(StatsResource.SIZE)
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
	new_attack.setup(frame_stats.get_stat(frame_stats.DAMAGE), global_position, frame_stats.get_stat(frame_stats.BUILDUP), status, self, 0, 0, frame_stats.get_stat(frame_stats.WEIGHT) * (frame_stats.get_stat(frame_stats.DAMAGE) / 30))
	#TODO: determine how to calculate knockback
	return new_attack

func die():
	queue_free()
