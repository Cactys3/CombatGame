extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/railgun/railgun_attachment.tscn")

## called in ready
func setdata():
	var descrip = "An attachment for a railgun."
	var image = preload("res://Art/New_Weapons/Railgun/Railgun_Attachment.png")
	data.setdata("RailA", descrip, ItemData.ATTACHMENT, "common", Color.AQUAMARINE, image, 5, 0.8)


##Projects a lazar beam aiming sight for awhile until firing a lazar blast that does a fuck ton of dmg and stuff.

var hitbox: CollisionShape2D

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	process_cooldown(delta)
	#52print(frame.stats.get_stat(StatsResource.COOLDOWN))
	#print("this: " + str(frame.stats.statsfactor.get(StatsResource.COOLDOWN)))

func attack():
	#play animation (has sound?) wait until animation is done, then shoot projectile, then wait and swap back to default animation
	visual.play("Attack")
	super()
