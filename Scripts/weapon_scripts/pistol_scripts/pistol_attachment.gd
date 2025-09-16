extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/pistol/pistol_attachment.tscn")

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
