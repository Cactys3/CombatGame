extends Projectile
class_name ItemProjectile
## Instead of being created by Weapon_Frame and Attachments/Handles, this is created by Items
func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
## Avoids Using Frame as we don't have it
func setup_item(base_stats: StatsResource, enemy_direction:Vector2):
	frame_stats = base_stats.get_copy(false) # get copy incase gun is freed
	frame_stats.parent_object_name = name
	frame = null
	var size_value = frame_stats.get_stat(StatsResource.SIZE) 
	self.scale = Vector2(size_value, size_value)
	direction = enemy_direction.normalized()
	piercing = frame_stats.get_stat(StatsResource.PIERCING)
	lifetime = frame_stats.get_stat(StatsResource.DURATION)
	damage = frame_stats.get_stat(frame_stats.DAMAGE) 
	speed = (frame_stats.get_stat(StatsResource.VELOCITY)) * 13
	buildup = frame_stats.get_stat(frame_stats.BUILDUP) 
	weight = (frame_stats.get_stat(frame_stats.WEIGHT))
	setdata()
## Override because this method uses weapon_frame 
func _on_body_entered(body: Node2D) -> void: 
	if dead:
		return
	if body.has_method("damage"):
		## We don't use the QueueAttacks here because we don't have a Weapon_Frame
		attack_body(body)
