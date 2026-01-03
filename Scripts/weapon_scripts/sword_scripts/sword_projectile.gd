extends Projectile

const type = preload("res://Scripts/weapon_scripts/sword_scripts/sword_projectile.gd")

#func get_instance():
	#var ret: type = preload("res://Scenes/Weapons/sword/sword_projectile.tscn").instantiate()
	#add_child(ret)
	#ret.status = ret.status.duplicate()
	#ret.stats = ret.stats.duplicate()
	#remove_child(ret)
	#return ret

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	super(delta)
## this can be overriden by polymorph (what's it called?) to do unique attacks
func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		var new_attack = make_attack()
		body.damage(new_attack)
		AttackedObjects.append(body)
## Randomize Stats
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret: StatsResource = StatsResource.new()
	#ret.set_stat_base(StatsResource.DAMAGE, randi_range(-1, 3))
	
	ret.parent_object_name = "Magic Ball Rolls"
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
