extends Attachment

@export var melee_hitbox: CollisionShape2D
@onready var anim: AnimationPlayer = $"Sword Animations"

@export var anim_pos: float :
	set(value):
		anim_pos = value
		position.x = value# * range_offset - Could do this instead of setting animation values
		handle.position.x = value# * range_offset

const ANIMATION_NAME = "attack"
var range_offset = 10
var base_range = 55
var speed: float = 1
var attacked_objects: Array[Node2D]

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	process_cooldown(delta)

func attack() -> void:
	attacked_objects = [] #empty attacked_objects list
	melee_hitbox.disabled = true #hit things again without having to leave their hitbox
	melee_hitbox.disabled = false
	
	frame.get_stat(StatsResource.DURATION)
	speed = 15 / frame.get_stat(StatsResource.VELOCITY) # to determine how fast (15 is default value or w/e)
	range_offset = abs(base_range - frame.get_stat(StatsResource.RANGE)) # to determine the length
	
	
	anim.play(ANIMATION_NAME, -1, speed) #TODO: change the second value (speed of animation) based on stats (speed, cooldown, time animation takes normally)
	
	anim.get_animation(ANIMATION_NAME).track_set_key_value(0, 1, base_range + range_offset)
	
	var animation_duration = anim.get_animation(ANIMATION_NAME).length / speed #TODO: not used
	var max_range_timeIndex = anim.get_animation(ANIMATION_NAME).track_get_key_time(0, 1)
	
	await get_tree().create_timer(max_range_timeIndex).timeout #wait until at max reach to fire projectile
	super()


#how should attachment extenders work?
#Create methods for ProcessCooldown(delta) and Attack() that extenders override.
#Create generic methods for creating a projectile with the right size/parent so extenders can use that
#extenders should always (with exceptions) call super on read and process 
#extenders have their own hitbox references and do all that themselves
#extenders have their own animations but have to include handle in these animations? or animations work to change position of weapon_frame?


func _on_body_entered(body: Node2D) -> void:
	if (attacking && !attacked_objects.has(body)): #Hit each enemy only once per melee attack
		var new_attack = make_attack()
		frame.hit_enemy(body, new_attack) #TODO: melee vs ranged dmg modifiers? this is melee
		attacked_objects.append(body)
