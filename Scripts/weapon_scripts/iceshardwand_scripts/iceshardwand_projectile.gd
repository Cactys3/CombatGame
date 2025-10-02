extends Projectile

@export var anim: AnimatedSprite2D

func get_instance():
	const type = preload("uid://dk67ukgy03cih")
	var ret: type = preload("uid://m37gbpi4rmf").instantiate()
	add_child(ret)
	ret.status = ret.status.duplicate()
	ret.stats = ret.stats.duplicate()
	remove_child(ret)
	return ret

## Remove movement code
func _process(delta: float) -> void:
	stopwatch += delta
	if (stopwatch > lifetime):
		die()


func attack_body(body: Node2D) -> void:
	if !AttackedObjects.has(body):
		if (anim.frame / anim.sprite_frames.get_frame_count(anim.animation)) > (collision_counter / piercing):
			anim.frame = (anim.frame + 1) % anim.sprite_frames.get_frame_count(anim.animation)
		super(body)
