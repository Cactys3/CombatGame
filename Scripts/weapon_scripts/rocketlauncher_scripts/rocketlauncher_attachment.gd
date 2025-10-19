extends Attachment

## Projectiles explode into copies of themselves on first collision
## Locked Piercing stat to 0?

var CloneDamagePercent: float = 0.3

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func projectile_died(pos: Vector2, is_clone: bool):
	## Don't create Clones for Clones
	if is_clone:
		return
	## Create Clones in a circle from original projectile's position
	var radial_offset: float = 0.0
	var count: float = frame.get_stat(StatsResource.COUNT) + StatsResource.get_default(StatsResource.COUNT)
	## At least have 3 clones min, but don't add 3 to count if count > 3
	if count < 3:
		count = 3
	for i:int in count:
		radial_offset += 1
		var angle = Vector2(1, 1).rotated(deg_to_rad((360 / count) * (radial_offset)))
		var proj = init_projectile(pos + angle, angle)
		## Clones do reduced damage
		proj.is_clone = true
		proj.damage = proj.damage * CloneDamagePercent
