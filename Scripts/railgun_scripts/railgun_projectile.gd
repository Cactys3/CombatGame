extends Projectile

const type = preload("res://Scripts/railgun_scripts/railgun_projectile.gd")

func get_instance():
	var ret: type = preload("res://Scenes/railgun/railgun_projectile.tscn").instantiate()
	add_child(ret)
	ret.status = ret.status.duplicate()
	ret.stats = ret.stats.duplicate()
	ret.my_stats = ret.my_stats.duplicate()
	remove_child(ret)
	if !(ret.status.attack_bleed + ret.stats.get_stat(stats.ATTACKSPEED) + ret.my_stats.get_stat(stats.ATTACKSPEED)) || !ret.status.attack_bleed || !ret.stats || !ret.my_stats:
		print("Determined that I need this print statment or the runtime will not load the @export variables from any custom resources. Must do something to Custom Resources before returning instance for all Projectiles (maybe other components too)" + str(ret.status.attack_bleed))
	return ret


## called in ready
func setdata():
	var descrip = "A projectile RAILGUN BEAM Cost/Mod: " + str(10) + str(0.8)
	var image = preload("res://Art/New_Weapons/Railgun/LazarBeam.png")
	data.setdata("Rail", descrip, ItemData.PROJECTILE, "rare", Color.PINK, image, 10, 0.8)


##projects a lazar before firing? or is that the attachment? just instantiates a really long beam in the direction that damages everything then fades quickly


func _process(delta: float) -> void:
	super(delta)
