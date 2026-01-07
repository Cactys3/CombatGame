extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/railgun/railgun_attachment.tscn")

##Projects a lazar beam aiming sight for awhile until firing a lazar blast that does a fuck ton of dmg and stuff.

var hitbox: CollisionShape2D

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func attack():
	#play animation (has sound?) wait until animation is done, then shoot projectile, then wait and swap back to default animation
	## TODO: Make projectile bigger
	visual.play("Attack")
	await visual.animation_finished
	super()
	visual.play("PostAttack")

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	set_stat_randomize(newstats, StatsResource.DAMAGE, randf_range(-0.5, 1.7), 0.01, 0)
	set_stat_randomize(newstats, StatsResource.ATTACKSPEED, randf_range(-0.3, 1.2), 0.01, 0)
	return newstats
