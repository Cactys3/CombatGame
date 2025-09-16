extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/railgun/railgun_handle.tscn")

##Static Slot and always points in one of the cardinal directions

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
	ready_to_fire = true
