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
