extends Components
class_name Projectile

func get_instance():
	return data.get_item().duplicate()

## In the future, maybe used to set Projectile specific stats
@export var stats: StatsResource #= StatsResource.new()
## Not decided, holds attack, defense, current values
#@export var status: StatusEffects = StatusEffects.new()
@export var status: StatusEffects #= StatusEffectDictionary.new()

## Is this projectile somehow not original/from gun
var is_clone: bool = false

var data: ItemData = ItemData.new()#ItemData.item_types.projectile, "projectile", StatsResource.new(), StatusEffects.new())
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
	set_stats()
	await get_tree().create_timer(0.02).timeout
	visible = true

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	frame_stats = base_gun.stats # get copy incase gun is freed
	frame_stats.parent_object_name = name
	frame = base_gun
	var size_value = frame_stats.get_stat(StatsResource.SIZE) 
	self.scale = Vector2(size_value, size_value)
	direction = enemy_direction.normalized()
	piercing = frame_stats.get_stat(StatsResource.PIERCING)
	lifetime = frame.get_stat(StatsResource.DURATION)
	damage = frame_stats.get_stat(frame_stats.DAMAGE) 
	speed = (frame.get_stat(StatsResource.VELOCITY)) * 13
	buildup = frame_stats.get_stat(frame_stats.BUILDUP) 
	weight = (frame_stats.get_stat(frame_stats.WEIGHT))
	setdata()

func set_stats() -> void:
	stats.set_changed_method(apply_stats)

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

func _on_body_entered(body: Node2D) -> void: 
	if dead:
		return
	if body.has_method("damage"):
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self))

func make_attack() -> Attack:
	var new_attack: Attack = Attack.new()
	if status:
		new_attack.setup(damage, global_position, buildup, status.AttackValues, self, 0, 0, weight * (damage / 30))
	else:
		new_attack.setup(damage, global_position, buildup, null, self, 0, 0, weight * (damage / 30))
	return new_attack

func die():
	visible = false
	dead = true
	died.emit(global_position, is_clone)
	queue_free()

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret = super(itemdata)
	ret.parent_object_name = "Projectile Rolls"
	return ret

func get_stats():
	return stats
