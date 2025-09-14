extends Projectile
class_name p

const type = preload("res://Scripts/weapon_scripts/pistol_scripts/pistol_bullet.gd")

func get_instance():
	var ret: type = preload("res://Scenes/Weapons/pistol/pistol_bullet.tscn").instantiate()
	add_child(ret)
	ret.status = ret.status.duplicate()
	ret.stats = ret.stats.duplicate()
	remove_child(ret)
	return ret

## called in ready
func setdata():
	var descrip = "A projectile PISTOL BULLET Cost/Mod: " + str(3) + str(0.8)
	var image = preload("res://Art/New_Weapons/Pistol/Bulletaseprite.png")
	pass#data.setdata("9mm", descrip, ItemData.PROJECTILE, "common", Color.DARK_ORANGE, image, 3, 0.8)

func _process(delta: float) -> void:
	super(delta)


func _ready() -> void:
	status = status.duplicate()
	stats = stats.duplicate()
