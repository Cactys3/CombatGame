extends Projectile

func get_scene() -> PackedScene:
	return preload("res://Scenes/pistol/pistol_bullet.tscn")

## called in ready
func setdata():
	var descrip = "A projectile PISTOL BULLET Cost/Mod: " + str(3) + str(0.8)
	var image = preload("res://Art/New_Weapons/Pistol/Bulletaseprite.png")
	data.setdata("9mm", descrip, ItemData.PROJECTILE, "common", Color.DARK_ORANGE, image, 3, 0.8)

func _process(delta: float) -> void:
	super(delta)
