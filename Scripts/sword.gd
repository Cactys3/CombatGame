extends Weapon
var attacked_objects: Array[Node2D]
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var stab_reach: float
const ANIMATION_NAME = "stab"
const ANIMATION_TIME = 1
var range_offset: float = -5

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	super(_delta)

func attack():
	stab_reach = weapon_range + range_offset
	anim.get_animation(ANIMATION_NAME).track_set_key_value(0, 1, Vector2(0, -stab_reach)) #sets a keyframe on track 1 at the time with a y value of -stab_reach
	anim.get_animation(ANIMATION_NAME).track_set_key_value(1, 1, Vector2(0, -stab_reach)) #same for track 2, effectively sets the range that the sword will stab to -stab_reach
	#print(anim.get_animation(ANIMATION_NAME).track_get_key_value(1, 0))
	#print(anim.get_animation(ANIMATION_NAME).track_get_key_value(1, 1))
	#print(anim.get_animation(ANIMATION_NAME).track_get_key_value(1, 2))
	attacked_objects.clear()
	anim.play(ANIMATION_NAME)
	await get_tree().create_timer(0.5).timeout
	super()

func _on_body_entered(body: Node2D) -> void:
	if (attacking && !attacked_objects.has(body)): #Hit each enemy only once per melee attack
		hit_enemy(body)
		attacked_objects.append(body)
