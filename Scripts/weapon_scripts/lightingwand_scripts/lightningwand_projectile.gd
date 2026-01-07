extends Projectile

## Does damage multiple times, times is equal to duration number

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void: 
	#unique mechanic: don't do movement
	#position += direction * speed * delta
	stopwatch += delta
	if (stopwatch > lifetime):
		die()

func die():
	if !dead:
		dead = true
		## unique: play death mechanic (fizzle out)
		anim.play("die")
		await get_tree().create_timer(3).timeout
		super()

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	## Set to 0
	set_stat_randomize(newstats, StatsResource.VELOCITY, 0, 0.01, 0)
	return newstats
