extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/railgun/railgun_handle.tscn")

## called in ready
func setdata():
	var descrip = "A railgun handle"
	var image = preload("res://Art/New_Weapons/Railgun/Railgun_Handle.png")
	data.setdata("RailgunH", descrip, ItemData.HANDLE, "common", Color.DARK_CYAN, image, 2, 0.8)


##Static Slot and always points in one of the cardinal directions

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
	ready_to_fire = true
