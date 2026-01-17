extends Attachment

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	var ret: Projectile = super(new_position, new_direction)
	ret.setup_return_to_sender(frame.player)
	return ret

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	arr.append(get_stat_upgrade(StatsResource.COUNT, randf_range(0.3, 1.1), itemdata.level, ItemData.get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.COUNT, randf_range(0, 1.5), 0.01, 0)
	return newstats
