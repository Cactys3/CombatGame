extends Attachment

##Projects a lazar beam aiming sight for awhile until firing a lazar blast that does a fuck ton of dmg and stuff.

var hitbox: CollisionShape2D

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	process_cooldown(delta)
	#52print(frame.stats.get_stat(StatsResource.COOLDOWN))
	#print("this: " + str(frame.stats.statsfactor.get(StatsResource.COOLDOWN)))

func process_cooldown(delta: float) -> void: 
	if attacking:
		pass
	elif cooldown_timer <= frame.get_stat(stats.COOLDOWN):
		cooldown_timer += delta
	elif handle.ready_to_fire:
		attacking = true
		attack() 

func attack():
	#play animation (has sound?) wait until animation is done, then shoot projectile, then wait and swap back to default animation
	visual.play("Attack")
	
	
	var new_bullet:Projectile = projectile.instantiate()
	new_bullet.global_position = global_position
	new_bullet.scale = frame.scale
	new_bullet.setup(frame, Vector2(cos(frame.rotation), sin(frame.rotation)))#TODO: try this
	get_tree().root.add_child(new_bullet)
	cooldown_timer = 0
	attacking = false
	print("awfewaf")
