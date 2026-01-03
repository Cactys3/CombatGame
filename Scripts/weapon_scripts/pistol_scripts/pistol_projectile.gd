extends Projectile
class_name p

const type = preload("uid://boxu6s6bh4u6w")

#func get_instance():
	#var ret: type = preload("res://Scenes/Weapons/pistol/pistol_bullet.tscn").instantiate()
	#add_child(ret)
	#ret.status = ret.status.duplicate()
	#ret.stats = ret.stats.duplicate()
	#remove_child(ret)
	#return ret

func _process(delta: float) -> void:
	super(delta)
