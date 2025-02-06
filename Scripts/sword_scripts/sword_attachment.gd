extends Attachment

@export var continous_hitbox: CollisionShape2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var anim_pos: float :
	set(value):
		anim_pos = value
		position.x = value * range_offset
		handle.position.x = value * range_offset

var range_offset = 1.2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	process_cooldown(delta)

func process_cooldown(delta: float) -> void:
	if attacking:
		pass
	elif cooldown_timer <= frame.get_stat(stats.COOLDOWN):
		cooldown_timer += delta
	elif handle.ready_to_fire:
		attacking = true
		attack()

func attack() -> void:
	#anim.get_animation(ANIMATION_NAME).track_set_key_value(0, 1, Vector2(0, -stab_reach)) #sets a keyframe on track 1 at the time with a y value of -stab_reach
	#anim.get_animation(ANIMATION_NAME).track_set_key_value(1, 1, Vector2(0, -stab_reach)) #same for track 2, effectively sets the range that the sword will stab to -stab_reach
	#print(cooldown_timer)
	#print(frame.get_stat(stats.COOLDOWN))
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
