extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/flamethrower/flamethrower_attachment.tscn")

#TODO: what does this do

func _ready() -> void:
	super()
