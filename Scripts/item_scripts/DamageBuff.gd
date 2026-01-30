extends Item

## Buffs Damage by 10%

## Code: Adds 10% to global stat?


func _process(delta: float) -> void:
	super(delta)
	#print(enabled)

func _ready() -> void:
	super()

func _connect_signals():
	super()

func enable():
	enabled = true
	manager.add_stats_item(self, stats)

func disable():
	enabled = false
	manager.remove_stats_item(self, stats)

static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade]
	arr.append(Components.get_stat_upgrade(StatsResource.DAMAGE, randf_range(0.2, 3), itemdata.level, ItemData.get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
