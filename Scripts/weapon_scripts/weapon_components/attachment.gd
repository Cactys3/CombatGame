extends Components
class_name Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/pistol/pistol_attachment.tscn")

var bullets: Array[Projectile]
## Determines what attackspeed is, attacksperX = 2 means attackspeed is how many attacks every 2 seconds
const attacksperX: int = 2

@export var MeleeDamageFactor: float = 1

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
	var inaccuracy: float =  stats.get_stat(StatsResource.INACCURACY) 
	var direction = Vector2(cos(frame.rotation), sin(frame.rotation)).rotated(deg_to_rad(randf_range(-inaccuracy, inaccuracy)))
	init_projectile(global_position, direction)
	# Create any extra bullets using @export values to offset them by angle and position
	var proj_offset: int = 0
	for i:int in frame.get_stat(StatsResource.COUNT) - 1:
		if i % 2 == 0:
			proj_offset += 1
		MultipleProjectileOffset *= -1
		MultipleProjectileAngleOffset *= -1
		init_projectile(global_position + Vector2(-sin(frame.rotation), cos(frame.rotation)).normalized() * MultipleProjectileOffset * (proj_offset), Vector2(cos(frame.rotation), sin(frame.rotation)))

func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	if projectile == null || !is_instance_valid(projectile):
		push_error("projectile null in attachment script")
		return null
	var new_bullet:Projectile = projectile.get_instance()
	new_bullet.visible = false
	new_bullet.setup(frame, new_direction)
	if (handle.AimType == Handle.AimTypes.Spinning): #handle aim types special cases
		frame.player.add_child(new_bullet)
	else:
		GameManager.instance.projectile_parent.add_child(new_bullet)
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
	return attacksperX / max(0.0001, frame.get_stat(StatsResource.ATTACKSPEED)) #attackspeed is attacks per second so cd is 1/as

## Send altered values because it's a melee hitbox
func make_attack() -> Attack:
	var new_attack: Attack = Attack.new()
	new_attack.setup(frame.stats.get_stat(stats.DAMAGE) * MeleeDamageFactor, frame.player.global_position, frame.stats.get_stat(StatsResource.BUILDUP), StatusEffectDictionary.new(), self, 0, 0, frame.stats.get_stat(StatsResource.WEIGHT) * (frame.stats.get_stat(StatsResource.DAMAGE) / 10))
	 #TODO: determine how to calculate knockback
	return new_attack

func set_stats() -> void:
	stats.connect_changed_signal(apply_stats)


## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	## Add Attackspeed in addition to super()'s Damage
	arr.append(get_stat_upgrade(StatsResource.ATTACKSPEED, randf_range(0.2, 2), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret = super(itemdata)
	ret.set_stat_base(StatsResource.ATTACKSPEED, randf_range(-0.2, 0.5))
	return ret

func get_stats():
	return stats
