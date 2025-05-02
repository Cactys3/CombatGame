extends Projectile
class_name p

const type = preload("res://Scripts/pistol_scripts/pistol_bullet.gd")

func get_instance():
	var ret: type = preload("res://Scenes/pistol/pistol_bullet.tscn").instantiate()
	add_child(ret)
	ret.status = ret.status.duplicate()
	ret.stats = ret.stats.duplicate()
	ret.my_stats = ret.my_stats.duplicate()
	remove_child(ret)
	#if !(ret.status.attack_bleed + ret.stats.get_stat(stats.ATTACKSPEED) + ret.my_stats.get_stat(stats.ATTACKSPEED)) || !ret.status.attack_bleed || !ret.stats || !ret.my_stats:
	#	print("Determined that I need this print statment or the runtime will not load the @export variables from any custom resources. Must do something to Custom Resources before returning instance for all Projectiles (maybe other components too)" + str(ret.status.attack_bleed))
	return ret

## called in ready
func setdata():
	var descrip = "A projectile PISTOL BULLET Cost/Mod: " + str(3) + str(0.8)
	var image = preload("res://Art/New_Weapons/Pistol/Bulletaseprite.png")
	data.setdata("9mm", descrip, ItemData.PROJECTILE, "common", Color.DARK_ORANGE, image, 3, 0.8)

func _process(delta: float) -> void:
	super(delta)


func _ready() -> void:
	print(status.get_local_scene())
	status = status.duplicate()
	my_stats = my_stats.duplicate()
