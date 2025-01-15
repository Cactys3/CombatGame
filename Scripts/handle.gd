extends Area2D
class_name Handle

@export var stats: StatsResource = StatsResource.new()

@export var visual: AnimatedSprite2D
@export var offset: Vector2
@export var frame: Weapon_Frame
@export var attachment: Attachment
@onready var player: Player_Script = get_tree().get_first_node_in_group("player")

@export var ORBIT_DISTANCE: float = 55
@export var ROTATION_SPEED: float = 20
var current_angle: float = 0  #Stores the angle for smooth circular motion
enum AimTypes{default, AtMouse, StaticSlot}
@export var AimType: AimTypes = AimTypes.default

func _process(_delta: float) -> void:
	match AimType:
		AimTypes.AtMouse:
			ProcessAtMouse(_delta)
		AimTypes.StaticSlot:
			ProcessStaticSlot(_delta)
		_:
			pass

func ProcessAtMouse(delta: float) -> void:
	#if attachment.ready_to_fire && frame.get_enemy_nearby(frame.get_stat(stats.RANGE)) != null:
	#	attachment.ready_to_fire = false
	#	attachment.attack()
	#Orbit Player Towards Mouse
	var target_angle = (get_global_mouse_position() - player.global_position).normalized().angle() + (TAU * (frame.weapon_slot/frame.weapon_count))
	var new_position = player.global_position + Vector2(cos(target_angle), sin(target_angle)) * ORBIT_DISTANCE
	frame.global_position = new_position
	#Rotate Towards Object
	var nearest_enemy = frame.get_enemy_nearby(frame.get_stat(stats.RANGE))
	print(nearest_enemy != null)
	if nearest_enemy != null:
		RotateTowardsPosition(nearest_enemy, delta)
	else:
		RotateTowardsPosition(get_global_mouse_position(), delta)

func ProcessStaticSlot(delta: float) -> void:
	if attachment.ready_to_fire && frame.get_enemy_nearby(frame.get_stat(stats.RANGE)) != null:
		attachment.ready_to_fire = false
		attachment.attack()
	#Orbit Player In Assigned Slot
	var target_angle = (TAU * (frame.weapon_slot/frame.weapon_count))
	var new_position = player.global_position + Vector2(cos(target_angle), sin(target_angle)) * ORBIT_DISTANCE
	frame.global_position = new_position
	#Rotate Towards Object
	var nearest_enemy = frame.get_enemy_nearby(frame.get_stat(stats.RANGE))
	if nearest_enemy != null:
		RotateTowardsPosition(nearest_enemy, delta)

func RotateTowardsPosition(new_position: Vector2, _delta: float) -> void:
	frame.rotation = lerp_angle(frame.rotation, (new_position - frame.global_position).normalized().angle() , ROTATION_SPEED * _delta)
 #TODO: try global_position instead of player.global_position for how weapon aiming looks
