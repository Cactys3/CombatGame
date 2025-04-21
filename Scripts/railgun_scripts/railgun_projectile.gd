extends Projectile

func get_scene() -> PackedScene:
	return preload("res://Scenes/railgun/railgun_projectile.tscn")

##projects a lazar before firing? or is that the attachment? just instantiates a really long beam in the direction that damages everything then fades quickly


func _process(delta: float) -> void:
	super(delta)
