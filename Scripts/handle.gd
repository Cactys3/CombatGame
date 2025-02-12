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

var ready_to_fire: bool = false #Tells attach if it can call Attack()

func _ready() -> void:
	stats.parent_object_name = name
	#stats = stats.duplicate()

func _process(_delta: float) -> void:
	match AimType:
		AimTypes.AtMouse:
			ProcessAtMouse(_delta)#each process must handle "ready_to_fire = true/false"
		AimTypes.StaticSlot:
			ProcessStaticSlot(_delta)
		_:
			pass

func ProcessAtMouse(delta: float) -> void:
	#Orbit Player Towards Mouse
	frame.global_position = GetOrbitPosition((get_global_mouse_position() - player.global_position).normalized().angle() + (TAU * (frame.weapon_slot/frame.weapon_count)))
	#Rotate Towards Object
	var nearest_enemy: Node2D = frame.get_enemy_nearby(frame.get_stat(stats.RANGE))
	if nearest_enemy != null:
		RotateTowardsPosition(nearest_enemy.global_position, delta)
		if !ready_to_fire && IsAimingAtEnemy(nearest_enemy):
			ready_to_fire = true
	else:
		RotateTowardsPosition(get_global_mouse_position(), delta)
		ready_to_fire = false

func ProcessStaticSlot(delta: float) -> void:
	#Orbit Player In Assigned Slot
	frame.global_position = GetOrbitPosition((TAU * (frame.weapon_slot/frame.weapon_count)))
	#Rotate Towards Object
	var nearest_enemy = frame.get_enemy_nearby(frame.get_stat(stats.RANGE))
	if nearest_enemy != null:
		#Rotate towards Enemy if exists
		RotateTowardsPosition(nearest_enemy.global_position, delta)
		if !ready_to_fire && (IsAimingAtEnemy(nearest_enemy)):
			#Ready To Fire if aiming close enough to enemy, stays ready to fire until we attack or enemy out of range
			ready_to_fire = true
	else:
		ready_to_fire = false

func RotateTowardsPosition(new_position: Vector2, _delta: float) -> void:
	frame.rotation = lerp_angle(frame.rotation, (new_position - frame.global_position).normalized().angle() , ROTATION_SPEED * _delta)
 #TODO: try global_position instead of player.global_position for how weapon aiming looks

func GetOrbitPosition(target_angle: float) -> Vector2:
	return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * ORBIT_DISTANCE

func IsAimingAtEnemy(enemy: Node2D) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(global_transform.x.normalized().dot((enemy.global_position - global_position).normalized())))
		return angle <= 8
	return false

func IsAimingAtEnemyWithinDegree(enemy: Node2D, degree: float) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(global_transform.x.normalized().dot((enemy.global_position - global_position).normalized())))
		return angle <= degree
	return false

## Setup this with raycasts or smth to tell if there's any enemy, maybe replace IsAimingAtEnemy
func IsAimingAtAnyEnemy() -> bool:
	if false: #TODO: setup with raycasts
		return true
	return false
