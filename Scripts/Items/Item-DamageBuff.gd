extends Item

## Buffs Damage by 10%

## Code: Adds 10% to global stat?

var Stats: StatsResource = StatsResource.new()

func _process(delta: float) -> void:
	super(delta)

func _ready() -> void:
	super()
	Stats.set_stat_factor(StatsResource.DAMAGE, 1.1)

func _connect_signals():
	super()

func enable():
	enabled = true
	Stats.set_stat_factor(StatsResource.DAMAGE, 1.1)
	manager.add_stats_item(self, Stats)

func disable():
	enabled = false
	manager.remove_stats_item(self, Stats)
