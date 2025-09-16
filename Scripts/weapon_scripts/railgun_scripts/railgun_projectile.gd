extends Projectile

const type = preload("res://Scripts/weapon_scripts/railgun_scripts/railgun_projectile.gd")

func get_instance():
	var ret: type = preload("res://Scenes/Weapons/railgun/railgun_projectile.tscn").instantiate()
	add_child(ret)
	ret.status = ret.status.duplicate()
	ret.stats = ret.stats.duplicate()
	remove_child(ret)
	return ret

##projects a lazar before firing? or is that the attachment? just instantiates a really long beam in the direction that damages everything then fades quickly


func _process(delta: float) -> void:
	super(delta)
