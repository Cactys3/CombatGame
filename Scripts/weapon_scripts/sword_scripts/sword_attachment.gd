extends Attachment

@export var melee_hitbox: CollisionShape2D
@onready var anim: AnimationPlayer = $"Sword Animations"

@export var anim_pos: float :
	set(value):
		if (self):
			anim_pos = value
			position.x = value# * range_offset - Could do this instead of setting animation values
			handle.position.x = value# * range_offset

const ANIMATION_NAME = "attack"
var range_offset = 10
var base_range = 30
var speed: float = 1
var attacked_objects: Array[Node2D]
var default_melee_damage_offset: float 

var time_spent_whilst_attacking: float = 0

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/sword/sword_attachment.tscn")

func _ready() -> void:
	super()
	default_melee_damage_offset = MeleeDamageFactor

func _process(delta: float) -> void:
	process_cooldown(delta)
	time_spent_whilst_attacking += delta

func attack() -> void:
	time_spent_whilst_attacking = 0
	attacked_objects = [] #empty attacked_objects list
	## Have 100% melee damage WHILE thrusting
	MeleeDamageFactor = 1
	## Attack things again without having to leave their hitbox (idk if this really works, idk if collisions methods would be called)
	melee_hitbox.disabled = true 
	melee_hitbox.disabled = false
	frame.get_stat(StatsResource.DURATION)
	speed = frame.get_stat(StatsResource.VELOCITY) * 0.01 ## TODO: Stat: Velocity # to determine how fast (15 is default value or w/e)
	range_offset = frame.get_stat(StatsResource.SIZE) * 10 # sword needs to go less range if its bigger to reach the same distance
	anim.play(ANIMATION_NAME, -1, speed) #TODO: change the second value (speed of animation) based on stats (speed, cooldown, time animation takes normally)
	anim.get_animation(ANIMATION_NAME).track_set_key_value(0, 1, frame.get_stat(StatsResource.RANGE) - range_offset)
	var animation_duration = anim.get_animation(ANIMATION_NAME).length / speed #TODO: not used
	var max_range_timeIndex = anim.get_animation(ANIMATION_NAME).track_get_key_time(0, 1)	
	await get_tree().create_timer(max_range_timeIndex).timeout #wait until at max reach to fire projectile
	super()
	## Account for time spent doing melee animation, this should count as attackspeed cooldown time
	cooldown_timer += time_spent_whilst_attacking
	## Melee damage is reduced whilst not thrusting
	MeleeDamageFactor = default_melee_damage_offset

func attack_body(body: Node, clone: bool) -> void:
	var new_attack = make_attack()
	body.damage(new_attack)

func _on_body_entered(body: Node2D) -> void:
	if (!attacked_objects.has(body) && body.has_method("damage")): #Hit each enemy only once per melee attack
		frame.QueuedAttacks.append(frame.AttackEvent.new(body, self, false)) #TODO: find out if really necessary to queue
		attacked_objects.append(body)

func _on_area_entered(area: Area2D) -> void:
	_on_body_entered(area)

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	arr.append(get_stat_upgrade(StatsResource.SIZE, randf_range(-0.1, 0.3), itemdata.level, get_weighted_rarity(itemdata.level), 0, 0.3))
	arr.append(get_stat_upgrade(StatsResource.RANGE, randf_range(1, 5), itemdata.level, get_weighted_rarity(itemdata.level), 0, 0.4))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.DAMAGE, randf_range(-0.5, 1.5), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.RANGE, randf_range(-4, 13), 0.01, 0.4)
	set_stat_randomize(newstats, StatsResource.SIZE, randf_range(-0.2, 0.6), 0.01, 0)
	return newstats
