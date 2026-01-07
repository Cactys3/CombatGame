extends Attachment

## Projectiles explode into copies of themselves on first collision
## Locked Piercing stat to 0?

var CloneDamagePercent: float = 0.3

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func projectile_died(pos: Vector2, is_clone: bool):
	## Don't create Clones for Clones
	if is_clone:
		return
	## Create Clones in a circle from original projectile's position
	var radial_offset: float = 0.0
	var count: float = frame.get_stat(StatsResource.COUNT) 
	## At least have 3 clones min, but don't add 3 to count if count > 3
	if count < 3:
		count = 3
	for i:int in count:
		radial_offset += 1
		var angle = Vector2(1, 1).rotated(deg_to_rad((360 / count) * (radial_offset)))
		var proj = init_projectile(pos + angle, angle)
		## Clones do reduced damage
		proj.is_clone = true
		proj.damage = proj.damage * CloneDamagePercent

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	arr.append(get_stat_upgrade(StatsResource.INACCURACY, randf_range(-1.6, -0.3), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	arr.append(get_stat_upgrade(StatsResource.ATTACKSPEED, randf_range(0.2, 1), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	arr.append(get_stat_upgrade(StatsResource.DAMAGE, randf_range(0.2, 1), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret = super(itemdata)
	ret.set_stat_base(StatsResource.DAMAGE, randf_range(-1, 3))
	ret.set_stat_base(StatsResource.ATTACKSPEED, randf_range(-1, 3))
	ret.set_stat_base(StatsResource.INACCURACY, randf_range(-2.5, -1))
	return ret
