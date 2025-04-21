extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/pistol/pistol_attachment.tscn")

## called in ready
func setdata():
	var descrip = "An attachment for a pistol."
	var image = preload("res://Art/New_Weapons/Pistol/Attachment_Pistol.png")
	data.setdata("PistolA", descrip, ItemData.ATTACHMENT, "common", Color.REBECCA_PURPLE, image, 3, 0.8)


func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
