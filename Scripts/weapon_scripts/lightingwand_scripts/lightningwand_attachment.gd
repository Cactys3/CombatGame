extends Attachment

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func create_projectiles():
	#unique mechanic: spawn projectile ontop of enemy
	var enemy = frame.get_enemy_nearby(frame.stats.get_stat(StatsResource.RANGE) * 20)
	print(enemy)
	if enemy != null:
		var enemypos = enemy.global_position
		# Create the first bullet by default
		init_projectile(enemypos, Vector2(cos(frame.rotation), sin(frame.rotation)))
		# Create any extra bullets using @export values to offset them by angle and position
		var offset: int = 0
		for i:int in frame.get_stat(StatsResource.COUNT) - 1:
			if i % 2 == 0:
				offset += 1
			MultipleProjectileOffset *= -1
			MultipleProjectileAngleOffset *= -1
			init_projectile(enemypos + Vector2(-sin(frame.rotation), cos(frame.rotation)).normalized() * MultipleProjectileOffset * (offset), Vector2(cos(frame.rotation), sin(frame.rotation)))
