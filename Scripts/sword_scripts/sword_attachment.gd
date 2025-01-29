extends Attachment

@export var continous_hitbox: CollisionShape2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	process_cooldown(delta)

func process_cooldown(delta: float) -> void:
	if attacking:
		pass
	elif cooldown_timer <= frame.get_stat(stats.COOLDOWN):
		cooldown_timer += delta
		print(cooldown_timer)
	elif handle.ready_to_fire:
		attacking = true
		attack()

func attack() -> void:
	var new_projectile: Projectile = init_projectile(global_position, frame.scale, Vector2(cos(frame.rotation), sin(frame.rotation)))
	#play animation
	cooldown_timer = 0
	attacking = false
#how should attachment extenders work?
#Create methods for ProcessCooldown(delta) and Attack() that extenders override.
#Create generic methods for creating a projectile with the right size/parent so extenders can use that
#extenders should always (with exceptions) call super on read and process 
#extenders have their own hitbox references and do all that themselves
#extenders have their own animations but have to include handle in these animations? or animations work to change position of weapon_frame?
