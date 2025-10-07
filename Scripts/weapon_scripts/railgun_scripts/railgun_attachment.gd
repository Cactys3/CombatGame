extends Attachment

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/railgun/railgun_attachment.tscn")

##Projects a lazar beam aiming sight for awhile until firing a lazar blast that does a fuck ton of dmg and stuff.

var hitbox: CollisionShape2D

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	process_cooldown(delta)

func attack():
	#play animation (has sound?) wait until animation is done, then shoot projectile, then wait and swap back to default animation
	visual.play("Attack")
	super()
