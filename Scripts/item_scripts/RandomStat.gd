extends Item

var stats: StatsResource

func _process(delta: float) -> void:
	super(delta)

func _ready() -> void:
	super()

func set_stats(new_stats: StatsResource):
	stats = new_stats
	var stat_name: String = StatsResource.get_rand_stat()
	var stat_value: float
	match(randi_range(0, 1)):
		0:
			stat_value = randf_range(0.05, 0.1)
			stats.set_stat_factor(stat_name, stat_value)
			data.item_description += " Plus: %" + str(stat_value) + " to " + stat_name.to_lower() 
			data.item_name += " Plus: %" + str(stat_value) + " to " + stat_name.to_lower() 
		1:
			stat_value = randf_range(10, 30)
			stats.set_stat_base(stat_name, stat_value)
			data.item_name += " Plus: " + str(stat_value) + " to " + stat_name.to_lower() 

func _connect_signals():
	super()

func enable():
	enabled = true
	manager.add_stats_item(self, stats)

func disable():
	enabled = false
	manager.remove_stats_item(self, stats)
