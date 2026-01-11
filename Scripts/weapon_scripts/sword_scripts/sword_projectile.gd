extends Projectile

const type = preload("res://Scripts/weapon_scripts/sword_scripts/sword_projectile.gd")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	super(delta)

func setup(base_gun:Weapon_Frame, enemy_direction:Vector2):
	super(base_gun, enemy_direction)
	## HardCode Piercing and Double Damage
	piercing = 0
	damage = damage * 2

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret = super(itemdata)
	ret.set_stat_base(StatsResource.PIERCING, randf_range(0, 0))
	return ret
