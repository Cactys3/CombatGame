extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/sword/sword_handle.tscn")

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret: StatsResource = StatsResource.new()
	ret.set_stat_base(StatsResource.DAMAGE, randf_range(-1, 3))
	ret.set_stat_base(StatsResource.CRITCHANCE, randf_range(-0.1, 0.24))
	ret.set_stat_base(StatsResource.CRITDAMAGE, randf_range(-0.3, 0.5))
	ret.parent_object_name = "Sword Hilt Rolls"
	return ret

## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade]
	var level: float = itemdata.level
	var level_multiplier: float = (1 + (level / 10))
	## First Upgrade
	var u1_rarity: ItemData.item_rarities = get_weighted_rarity(level)
	var u1: ItemData.LevelUpgrade = ItemData.LevelUpgrade.new()
	u1.setup(StatsResource.DAMAGE, u1_rarity, false, get_damage_upgrade(level, u1_rarity))
	arr.append(u1)
	return arr
