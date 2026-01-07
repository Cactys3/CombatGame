extends Projectile
class_name p

const type = preload("uid://boxu6s6bh4u6w")

#func get_instance():
	#var ret: type = preload("res://Scenes/Weapons/pistol/pistol_bullet.tscn").instantiate()
	#add_child(ret)
	#ret.status = ret.status.duplicate()
	#ret.stats = ret.stats.duplicate()
	#remove_child(ret)
	#return ret

func _process(delta: float) -> void:
	super(delta)

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.VELOCITY, randf_range(-2, 15), 0.01, 0)
	return newstats
