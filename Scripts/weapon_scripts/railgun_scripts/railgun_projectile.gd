extends Projectile

const type = preload("res://Scripts/weapon_scripts/railgun_scripts/railgun_projectile.gd")
@onready var collision: CollisionShape2D = $CollisionShape2D

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	super(base_gun, enemy_direction)
	## Convert Piercing, Speed, Count into Damage
	piercing = 0
	speed = 0
	count = 0
	lifetime = 0.1
	scale = vectorify(frame_stats.get_stat(StatsResource.SIZE)) + vectorify(frame_stats.get_stat(StatsResource.PIERCING) / 4) + vectorify(frame_stats.get_stat(StatsResource.COUNT) / 4)
	damage = frame_stats.get_stat(StatsResource.DAMAGE) + (frame_stats.get_stat(StatsResource.PIERCING) / 2) + (frame_stats.get_stat(StatsResource.COUNT) / 2) + (frame_stats.get_stat(StatsResource.VELOCITY) / 20)
func vectorify(num: float) -> Vector2:
	return Vector2(num, num)
## Railgun Beam Doesn't Move

var new_stopwatch: float = 0
func _process(delta: float) -> void:
	super(delta)
	new_stopwatch += delta
	if new_stopwatch >= 1:
		new_stopwatch = 0
		AttackedObjects.clear()
		collision.disabled = true
		collision.call_deferred("set_disabled", false)

func process_movement(delta: float) -> void:
	#if get_parent() != frame: Funny Lightsaber Idea
		#reparent(frame)
	pass

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret: StatsResource = super(itemdata)
	ret.set_stat_base(StatsResource.VELOCITY, randf_range(0, 0))
	ret.set_stat_base(StatsResource.PIERCING, randf_range(0, 0))
	ret.set_stat_base(StatsResource.COUNT, randf_range(0, 0))
	ret.set_stat_base(StatsResource.DURATION, randf_range(-1, 4))
	return ret
