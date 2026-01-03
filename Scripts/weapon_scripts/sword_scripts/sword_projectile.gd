extends Projectile

const type = preload("res://Scripts/weapon_scripts/sword_scripts/sword_projectile.gd")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	super(delta)
## this can be overriden by polymorph (what's it called?) to do unique attacks
func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		body.damage(new_attack)
		AttackedObjects.append(body)
## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	## Add Attackspeed in addition to super()'s Damage
	#arr.append(get_stat_upgrade(StatsResource.ATTACKSPEED, randf_range(0.2, 2), itemdata.level, get_weighted_rarity(itemdata.level), 0.01, 0))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret = super(itemdata)
	#ret.set_stat_base(StatsResource.DAMAGE, randi_range(-1, 3))
	ret.parent_object_name = "Magic Ball Rolls"
	return ret
