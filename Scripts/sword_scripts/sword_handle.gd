extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/sword/sword_handle.tscn")

## called in ready
func setdata():
	var descrip = "A sword handle"
	var image = preload("res://Art/New_Weapons/Sword/Handle_Sword.png")
	data.setdata("SwordH", descrip, ItemData.HANDLE, "common", Color.DARK_CYAN, image, 2, 0.8)

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
