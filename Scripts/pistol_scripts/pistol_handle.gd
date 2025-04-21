extends Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/pistol/pistol_handle.tscn")

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
