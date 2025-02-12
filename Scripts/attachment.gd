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
#new stuff
var cooldown_timer: float = 0
var attacking: bool = false

func _ready() -> void:
	stats.parent_object_name = name
	#stats = stats.duplicate()
	cooldown_timer = 0

func _process(delta: float) -> void:
	process_cooldown(delta)

## Should handle cooldown and calling attack()
## this is meant to be overridden by classes that inherit it
func process_cooldown(delta: float) -> void: 
	if attacking:
		pass
	elif cooldown_timer <= frame.get_stat(stats.COOLDOWN):
		cooldown_timer += delta
	elif handle.ready_to_fire:
		attacking = true
		attack() 

## Should handle creating a projectile, shooting it, and reseting cooldown
## this is meant to be overridden by classes that inherit it
func attack(): 
	#projectile = preload("res://Scenes/luger_bullet.tscn")
	#print(projectile.resource_name)
	var new_bullet:Projectile = projectile.instantiate()
	new_bullet.global_position = global_position
	new_bullet.scale = frame.scale
	new_bullet.setup(frame, Vector2(cos(frame.rotation), sin(frame.rotation)))#TODO: try this
	get_tree().root.add_child(new_bullet)
	cooldown_timer = 0
	attacking = false

func init_projectile(new_position: Vector2, new_scale: Vector2, new_direction: Vector2) -> Projectile:
	if projectile == null:
		push_error("projectile null in attachment script")
		return null
	var new_bullet:Projectile = projectile.instantiate()
	new_bullet.global_position = new_position
	new_bullet.scale = new_scale
	new_bullet.setup(frame, new_direction)
	get_tree().root.add_child(new_bullet)#TODO: maybe better options exist
	return new_bullet


#how should attachment extenders work?
#Create methods for ProcessCooldown(delta) and Attack() that extenders override.
#Create generic methods for creating a projectile with the right size/parent so extenders can use that
#extenders should always (with exceptions) call super on read and process 
#extenders have their own hitbox references and do all that themselves
#extenders have their own animations but have to include handle in these animations? or animations work to change position of weapon_frame?
