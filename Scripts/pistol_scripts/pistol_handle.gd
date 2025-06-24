extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/pistol/pistol_handle.tscn")

## called in ready
func setdata():
	var descrip = "A pistol handle"
	var image = preload("res://Art/New_Weapons/Pistol/Handle_Pistol.png")
	data.setdata("PistolH", descrip, ItemData.HANDLE, "common", Color.DARK_MAGENTA, image, 6, 0.8)


func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
