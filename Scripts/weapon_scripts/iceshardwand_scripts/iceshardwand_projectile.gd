extends Projectile

@export var anim: AnimatedSprite2D

var fadingout: bool = false
var AttackedBodyCd: int = 1
var AttackedBodyStopwatch: float = 0
var anim_length: float = 1

func _ready() -> void:
	anim_length = anim.sprite_frames.get_frame_count(anim.animation) - 1

## Remove movement code
func _process(delta: float) -> void:
	if !fadingout && anim.frame == anim.sprite_frames.get_frame_count(anim.animation) - 1:
		anim.play("FadeOut")
		fadingout = true
	
	AttackedBodyStopwatch += delta
	if AttackedBodyStopwatch >= AttackedBodyStopwatch:
		AttackedObjects.clear()
	
	stopwatch += delta
	if (stopwatch > lifetime):
		die()

func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		super(body)
		if piercing > 0:
			anim.frame = ceilf((collision_counter / piercing) * anim_length)
		
