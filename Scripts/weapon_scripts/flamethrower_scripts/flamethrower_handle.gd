extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/flamethrower/flamethrower_handle.tscn")

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
