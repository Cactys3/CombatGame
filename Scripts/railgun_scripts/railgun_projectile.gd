extends Projectile

func get_scene() -> PackedScene:
	return preload("res://Scenes/railgun/railgun_projectile.tscn")

## called in ready
func setdata():
	var descrip = "A projectile RAILGUN BEAM Cost/Mod: " + str(10) + str(0.8)
	var image = preload("res://Art/New_Weapons/Railgun/LazarBeam.png")
	data.setdata("Rail", descrip, ItemData.PROJECTILE, "rare", Color.PINK, image, 10, 0.8)


##projects a lazar before firing? or is that the attachment? just instantiates a really long beam in the direction that damages everything then fades quickly


func _process(delta: float) -> void:
	super(delta)
