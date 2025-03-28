extends Area2D
class_name Attachment
#Stat Modifiers

@export var stats: StatsResource = StatsResource.new()

var bullets: Array[Projectile]

@export var visual: AnimatedSprite2D 
@export var offset: Vector2 
@export var frame: Weapon_Frame 
@export var handle: Handle
@export var projectile: PackedScene
@export var MultipleProjectileOffset: float = 2
@export var MultipleProjectileAngleOffset: float = 2
#new stuff
var cooldown_timer: float = 0
var attacking: bool = false

func _ready() -> void:
	stats.parent_object_name = name
	#stats = stats.duplicate()
	cooldown_timer = 0

func _process(delta: float) -> void:
	#print(name + " has projectile: " + frame.projectile.resource_path + "!")
	#print(name + "frame: " + str(frame.stats.get_stat(StatsResource.SIZE)) + "Handle: " +  str(stats.get_stat(StatsResource.SIZE)) + "Attachment: " +  str(frame.handle.stats.get_stat(StatsResource.SIZE)) + "scale: " + str(scale))
	
	process_cooldown(delta)

## Should handle cooldown and calling attack()
## this is meant to be overridden by classes that inherit it
func process_cooldown(delta: float) -> void: 
	if attacking:
		pass
	elif cooldown_timer <= get_cooldown():
		cooldown_timer += delta
	elif handle.ready_to_fire:
		attacking = true
		attack() 

## Should handle creating a projectile, shooting it, and reseting cooldown
## this is meant to be overridden by classes that inherit it
func attack(): 
	create_projectiles()
	# Reset attack values so we can attack again
	cooldown_timer = 0
	attacking = false

func create_projectiles():
	# Create the first bullet by default
	var new_bullet:Projectile = projectile.instantiate()
	#new_bullet.scale = frame.scale
	new_bullet.setup(frame, Vector2(cos(frame.rotation), sin(frame.rotation)))
	if (handle.AimType == Handle.AimTypes.Spinning): #handle aim types special cases
		get_tree().root.add_child(new_bullet)
	else:
		get_tree().root.add_child(new_bullet)
	new_bullet.global_position = global_position
	
	# Create any extra bullets using @export values to offset them by angle and position
	var offset: int = 0
	for i:int in frame.get_stat(StatsResource.COUNT) - 1:
		if i % 2 == 0:
			offset += 1
		MultipleProjectileOffset *= -1
		MultipleProjectileAngleOffset *= -1
		new_bullet = projectile.instantiate()
		#new_bullet.scale = frame.scale
		var target_angle = Vector2(cos(frame.rotation), sin(frame.rotation)).rotated(MultipleProjectileAngleOffset * (offset) * 0.01)
		new_bullet.setup(frame, target_angle)
		if (handle.AimType == Handle.AimTypes.Spinning): #handle aim types special cases
			frame.player.add_child(new_bullet)
		else:
			get_tree().root.add_child(new_bullet)
		new_bullet.global_position = global_position + Vector2(-sin(frame.rotation), cos(frame.rotation)).normalized() * MultipleProjectileOffset * (offset)

func indit_projectile(new_position: Vector2, new_scale: Vector2, new_direction: Vector2) -> Projectile:
	if projectile == null:
		push_error("projectile null in attachment script")
		return null
	var new_bullet:Projectile = projectile.instantiate()
	#new_bullet.scale = new_scale
	new_bullet.setup(frame, new_direction)
	if (handle.AimType == Handle.AimTypes.Spinning): #handle aim types special cases
		frame.player.add_child(new_bullet)
	else:
		get_tree().root.add_child(new_bullet)
	new_bullet.global_position = new_position
	
	return new_bullet

func get_cooldown() -> float:
	return 1 / frame.get_stat(StatsResource.ATTACKSPEED) #attackspeed is attacks per second so cd is 1/as

func make_attack() -> Attack:
	var new_attack: Attack = Attack.new()
	new_attack.damage = stats.get_stat(stats.DAMAGE)
	new_attack.knockback = stats.get_stat(stats.WEIGHT) * (stats.get_stat(stats.DAMAGE) / 10) #TODO: determine how to calculate knockback
	new_attack.position = frame.player.global_position
	new_attack.bleed = 0
	new_attack.burn = 0
	new_attack.toxic = 0
	new_attack.slow = 0
	new_attack.stun = 0
	new_attack.rage = 0
	return new_attack

#how should attachment extenders work?
#Create methods for ProcessCooldown(delta) and Attack() that extenders override.
#Create generic methods for creating a projectile with the right size/parent so extenders can use that
#extenders should always (with exceptions) call super on read and process 
#extenders have their own hitbox references and do all that themselves
#extenders have their own animations but have to include handle in these animations? or animations work to change position of weapon_frame?
