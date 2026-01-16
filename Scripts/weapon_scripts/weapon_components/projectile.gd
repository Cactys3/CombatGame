extends Components
class_name Projectile

func get_instance():
	return data.get_item().duplicate()

## Not decided, holds attack, defense, current values
@export var status: StatusEffects
## If Count > 1 should spawn multiple version of this projectile (usually scales with count some other way if not)
@export var can_spawn_multiple: bool = true
@export var can_die_from_collision: bool = true
@export var can_die_from_lifespan: bool = true

var frame: Weapon_Frame
var damage: float
var critchance: float
var critdamage: float
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

const speed_stat_offset: float = 3

## Is this projectile somehow not original/from gun
var is_clone: bool = false
var damage_offset: float = 0.5
## Is this return_to_sender?
var return_to_sender: bool = false
var sender: Node2D

var dead: bool = false
signal died(pos: Vector2, cloned: bool)
## wait 0.2 sec before showing 
func _ready():
	## TODO: fix the issue where bullets flash around the screen when created
	visible = false
	await get_tree().create_timer(0.01).timeout
	visible = true
## Called to setup this projectile, must be called for projectile to work
func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	frame = base_gun
	set_stats()
	setdata()
	frame_stats = base_gun.stats 
	var size = StatsResource.calculate_scale(frame_stats.get_stat(StatsResource.SIZE))
	scale = Vector2(size, size)
	direction = enemy_direction.normalized()
	## TODO: Stat
	piercing = frame_stats.get_stat(StatsResource.PIERCING)
	lifetime = frame_stats.get_stat(StatsResource.DURATION)
	damage = frame_stats.get_stat(StatsResource.DAMAGE) 
	speed = speed_stat_offset * (frame_stats.get_stat(StatsResource.VELOCITY))
	buildup = frame_stats.get_stat(StatsResource.BUILDUP) 
	weight = (frame_stats.get_stat(StatsResource.WEIGHT))
	count = frame_stats.get_stat((StatsResource.COUNT))
	critchance = frame_stats.get_stat(StatsResource.CRITCHANCE)
	critdamage = frame_stats.get_stat(StatsResource.CRITDAMAGE)
## Called if this projectile is a clone
func setup_clone(new_damage_offset: float):
	damage_offset = new_damage_offset
	is_clone = true
## Called if this projectile should return_to_sender
func setup_return_to_sender(player: Node2D):
	return_to_sender = true
	sender = player
## if not dead, process_movement 
func _process(delta: float) -> void: #TODO: testing pyhsics_process vs process (and queued attacks)
	if dead:
		return
	if return_to_sender && sender:
		## Change direction to point towards player, change direction faster the farther from player we are
		direction = direction.move_toward((sender.global_position - global_position).normalized(), delta * clamp(global_position.distance_to(sender.global_position), 0.1, INF) / 200)
	process_movement(delta)
	stopwatch += delta
	if (stopwatch > lifetime && can_die_from_lifespan):
		die()
## Adds direction * speed * delta to position, moving normally
func process_movement(delta: float) -> void:
	position += direction * speed * delta

## this can be overriden by polymorph (what's it called?) to do unique attacks
func attack_body(body: Node2D, clone: bool) -> void:
	if dead:
		return
	if !AttackedObjects.has(body):
		var new_attack = make_attack(clone)
		body.damage(new_attack)
		collision_counter += 1
		AttackedObjects.append(body)
		if (collision_counter > piercing && can_die_from_collision):
			die() 
## if not dead, check if body has body.damage()
func _on_body_entered(body: Node2D) -> void: 
	if dead:
		return
	if body.has_method("damage"):
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self, is_clone))
## Return an attack from this projectile
func make_attack(clone: bool) -> Attack:
	var new_attack: Attack
	var attack_damage: float = StatsResource.calculate_damage(damage, critchance, critdamage)
	if clone:
		attack_damage = damage * damage_offset
		print("is clone so damage is changed: " + str(damage) + " vs " + str(damage) + " * " + str(damage_offset) + " = " + str(attack_damage))
	if status:
		new_attack = Attack.new(attack_damage, global_position, buildup, status.AttackValues, self, 0, 0, weight * (attack_damage / 30))
	else:
		new_attack = Attack.new(attack_damage, global_position, buildup, null, self, 0, 0, weight * (attack_damage / 30))
	return new_attack
## setup this projectile to queue_free(), then queue_free()
func die():
	visible = false
	dead = true
	died.emit(global_position, is_clone)
	queue_free()

## ItemData methods:
func set_stats() -> void:
	stats.connect_changed_signal(apply_stats)
func setdata():
	pass
func getdata() -> ItemData:
	return data
func get_stats():
	return stats
## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	## Don't set equal to super() as we don't want to include damage
	var arr: Array[ItemData.LevelUpgrade]
	arr.append(get_stat_upgrade(StatsResource.VELOCITY, randf_range(2, 3), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0.3))
	arr.append(get_stat_upgrade(StatsResource.COUNT, randf_range(0.1, 0.4), 1, get_weighted_rarity(itemdata.level), 0.01, 0.3))
	arr.append(get_stat_upgrade(StatsResource.PIERCING, randf_range(0.5, 1), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0.3))
	arr.append(get_stat_upgrade(StatsResource.DURATION, randf_range(2, 5), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0.3))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret = super(itemdata)
	ret.set_stat_base(StatsResource.VELOCITY, randf_range(-4, 7))
	ret.set_stat_base(StatsResource.PIERCING, randf_range(-1, 2))
	ret.set_stat_base(StatsResource.COUNT, randf_range(-0.2, 0.5))
	ret.set_stat_base(StatsResource.DURATION, randf_range(-1, 3))
	return ret
