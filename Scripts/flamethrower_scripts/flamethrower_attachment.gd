extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/flamethrower/flamethrower_attachment.tscn")

#TODO: what does this do

func _ready() -> void:
	super()

## called in ready
func setdata():
	var descrip = "An attachment for a flamethrower."
	var image = preload("res://Art/New_Weapons/flamethrower/Attachment_Flamethrower.png")
	data.setdata("Flame", descrip, ItemData.ATTACHMENT, "common", Color.CORAL, image, 5, 0.8)


func _process(delta: float) -> void:
	super(delta)
	#52print(frame.stats.get_stat(StatsResource.COOLDOWN))
	#print("this: " + str(frame.stats.statsfactor.get(StatsResource.COOLDOWN)))
