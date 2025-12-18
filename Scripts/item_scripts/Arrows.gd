extends Item

var status: StatusEffects = null
var stats: StatsResource = null
var curr_timer: float = 0
var max_timer: float = 3
@export var projectile: PackedScene

## Shoots X arrow(s) every X seconds, they do 
func _ready() -> void:
	super()

func _process(delta: float) -> void:
	if enabled:
		curr_timer = curr_timer + delta
		#print(curr_timer)
		if curr_timer >= max_timer:
			create_projectiles()
			curr_timer = 0

func set_stats(new_stats: StatsResource):
	stats = new_stats

func create_projectiles():
	var direction_angle: float = randf_range(0, 2 * PI)
	# Create First Projectile at angle 0, with homing
	# Randomize Direction Based on inaccuracy
	var global_position: Vector2 = GameManager.instance.player.global_position
	var inaccuracy: float =  stats.get_stat(StatsResource.INACCURACY) 
	var direction = Vector2(cos(direction_angle), sin(direction_angle)).rotated(deg_to_rad(randf_range(-inaccuracy, inaccuracy)))
	init_projectile(global_position, direction)
	# Create Rest of Projectiles at increasing angles around the player, with homing
	# Randomize Direction Based on inaccuracy
	var proj_offset: int = 0
	var MultipleProjectileOffset = 5
	var MultipleProjectileAngleOffset = 5
	for i:int in stats.get_stat(StatsResource.COUNT) - 1:
		if i % 2 == 0:
			proj_offset += 1
		MultipleProjectileOffset *= -1
		MultipleProjectileAngleOffset *= -1
		init_projectile(global_position + Vector2(-sin(direction_angle), cos(direction_angle)).normalized() * MultipleProjectileOffset * (proj_offset), Vector2(cos(direction_angle), sin(direction_angle)))

func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	if projectile == null:
		push_error("projectile null in attachment script")
		return null
	var new_bullet:Projectile = projectile.instantiate()
	new_bullet.visible = false
	new_bullet.setup_item(stats, new_direction)
	GameManager.instance.weapon_parent.add_child(new_bullet)
	new_bullet.global_position = new_position
	new_bullet.rotation = new_direction.normalized().angle()
	#new_bullet.died.connect(projectile_died)
	return new_bullet
