extends Projectile

## Does damage multiple times, times is equal to duration number
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	super()
	anim.animation_finished.connect(pulse)
	anim.play("SparkIn")

var pulse_count: float = 1
func pulse():
	## it turns visible = false somewhere, maybe FadeOut 
	visible = true
	## Finishes 2 animations per pulse, so add 0.5
	pulse_count += 0.5
	## Reset Pulse
	if anim.animation == "FadeOut":
		anim.play("SparkIn")
		AttackedObjects.clear()
		collision.disabled = false
	else:
		## Die after pulsing, scaling with count (do it here bc die() calls FadeOut)
		if pulse_count > count:
			die()
			return
		anim.play("FadeOut")
		collision.disabled = true

## Lightning doesn't move
func process_movement(delta: float) -> void:
	pass

func die():
	if !dead:
		dead = true
		## unique: play death mechanic (fizzle out)
		anim.play("FadeOut")
		await anim.animation_finished
		super()

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var newstats: StatsResource = super(itemdata)
	## Set to 0
	set_stat_randomize(newstats, StatsResource.VELOCITY, 0, 0, 0)
	set_stat_randomize(newstats, StatsResource.PIERCING, 0, 0, 0)
	return newstats
