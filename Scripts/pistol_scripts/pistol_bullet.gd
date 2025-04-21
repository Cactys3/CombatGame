extends Projectile

func get_scene() -> PackedScene:
	return preload("res://Scenes/pistol/pistol_bullet.tscn")

func _process(delta: float) -> void:
	super(delta)
