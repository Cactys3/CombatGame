extends Components
class_name Handle

func get_scene() -> PackedScene:
	return preload("res://Scenes/Weapons/pistol/pistol_handle.tscn")
@export_category("Generic Settings")
@export var visual: AnimatedSprite2D
## Can ignore the ready_to_fire variable and assume always ready to fire = true
@export var always_ready_to_fire: bool = false
@export_category("Aim Settings")
@export var AimType: AimTypes = AimTypes.default
@export_category("Orbit Settings")
@export var orbit_distance: float = 55
@export var offset: Vector2

var rotation_speed: float = 20
var weapon_slot: float = 1
var weapon_count: float = 1
var frame: Weapon_Frame
var attachment: Attachment
@onready var player: Character = get_tree().get_first_node_in_group("player")
var spinning_offset: float = 0
var spinning_speed: float = 3

var current_angle: float = 0  #Stores the angle for smooth circular motion
enum AimTypes{default, DynamicAtMouse, AlwaysAtMouse, StaticSlot, Spinning, Unique}

var temp_value = 0
#TODO: Used by all handles to tell how many of each aim type there are?
# probably just keep track in player tbh
static var StaticAimCount
static var MouseAimCount
static var SpinAimCount
static var UnqiueAimCount
var ready_to_fire: bool = false #Tells attach if it can call Attack()

func _ready() -> void:
	set_stats()
	stats.setup(name)
	setdata()
func _process(_delta: float) -> void:
	match AimType:
		AimTypes.DynamicAtMouse:
			ProcessDynamicAtMouse(_delta)
		AimTypes.AlwaysAtMouse:
			ProcessAlwaysAtMouse(_delta)
		AimTypes.StaticSlot:
			ProcessStaticSlot(_delta)
		AimTypes.Spinning:
			ProcessSpinning(_delta)
		_:
			ProcessUnique(_delta)
## Process Aiming Methods
## Aim at any enemy in range, else aim at mouse, rotating around player towards mouse
func ProcessDynamicAtMouse(delta: float) -> void:
	#Orbit Player Towards Mouse
	var alternating_sign: float = 1
	if (int(weapon_slot) % 2) == 0: #alternate being left of 1st weapon and right
		alternating_sign = -1
	var temp_slot_variable: float = weapon_slot
	if weapon_slot > 2:
		if (int(weapon_slot) % 2) != 0: #make distance only increase once a sword has been added on both left and right with same distance
			temp_slot_variable = (weapon_slot + 1) / 2
		else:
			temp_slot_variable = (weapon_slot + 2) / 2
	var slot_offset_value = alternating_sign * ((TAU / 30) * ((temp_slot_variable - 1)))
	frame.global_position = GetOrbitPosition((get_global_mouse_position() - player.global_position).normalized().angle() + slot_offset_value)
	#Rotate Towards Object
	var nearest_enemy: Node2D = frame.get_enemy_nearby(frame.get_stat(stats.RANGE))
	if nearest_enemy != null:
		RotateTowardsPosition(nearest_enemy.global_position, delta)
		if !ready_to_fire && IsAimingAtEnemy(nearest_enemy):
			ready_to_fire = true
	else:
		RotateTowardsPosition(get_global_mouse_position(), delta)
		ready_to_fire = false
## Aim always at mouse, rotating around player towards mouse
func ProcessAlwaysAtMouse(delta: float) -> void:
	#Orbit Player Towards Mouse
	var alternating_sign: float = 1
	if (int(weapon_slot) % 2) == 0: #alternate being left of 1st weapon and right
		alternating_sign = -1
	var temp_slot_variable: float = weapon_slot
	if weapon_slot > 2:
		if (int(weapon_slot) % 2) != 0: #make distance only increase once a sword has been added on both left and right with same distance
			temp_slot_variable = (weapon_slot + 1) / 2
		else:
			temp_slot_variable = (weapon_slot + 2) / 2
	var slot_offset_value = alternating_sign * ((TAU / 30) * ((temp_slot_variable - 1)))
	frame.global_position = GetOrbitPositionAtMouse((get_global_mouse_position() - player.global_position).normalized().angle() + slot_offset_value)
	#Rotate Towards Object
	var nearest_enemy: Node2D = frame.get_enemy_nearby(frame.get_stat(stats.RANGE))
	if nearest_enemy != null:
		if !ready_to_fire && IsAimingAtEnemy(nearest_enemy):
			ready_to_fire = true
	else:
		ready_to_fire = false
	RotateTowardsPosition(get_global_mouse_position(), delta)
## Aim at nearest enemy from static slot
func ProcessStaticSlot(delta: float) -> void:
	#Orbit Player In Assigned Slot
	var temp_count: float = weapon_count
	if (temp_count < 4):
		temp_count = 4
	frame.global_position = GetOrbitPosition((TAU * (weapon_slot / temp_count)))#weapon_count)))
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
## Spin around player, aiming directly outward from center
func ProcessSpinning(delta: float) -> void:
	spinning_offset += delta * spinning_speed #TODO: Have a static value between all handles used to know how many of each aim type there are?
	frame.global_position = GetOrbitPosition(spinning_offset + (TAU * (weapon_slot))) #should be used if there are multiple spinning weapons
	frame.rotation = spinning_offset + (TAU * (weapon_slot)) #face directly outward (works?)
	ready_to_fire = true
## Overriden method to aim uniquely
func ProcessUnique(_delta: float) -> void:
	pass
## rotates this weapon towards the new position, TODO: lerp calculated with weight
func RotateTowardsPosition(new_position: Vector2, _delta: float) -> void:
	frame.rotation = lerp_angle(frame.rotation, (new_position - frame.global_position).normalized().angle() , rotation_speed * _delta)
 #TODO: try global_position instead of player.global_position for how weapon aiming looks
## Calculates the orbit position for a weapon at given target_angle
func GetOrbitPosition(target_angle: float) -> Vector2:
	return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * orbit_distance# * (frame.get_stat(StatsResource.SIZE)) #TODO: implement scale better with offset
func GetOrbitPositionAtMouse(target_angle: float) -> Vector2:
	if player.global_position.distance_to(get_global_mouse_position()) < orbit_distance:
		return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * (player.global_position.distance_to(get_global_mouse_position()) - 1)
	return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * orbit_distance
## Returns if weapon is pointing towards the given enemy
func IsAimingAtEnemy(enemy: Node2D) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(global_transform.x.normalized().dot((enemy.global_position - global_position).normalized())))
		return angle <= 5
	return false
## Returns if weapon is pointing towards the given enemy, within degree of leniency
func IsAimingAtEnemyWithinDegree(enemy: Node2D, degree: float) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(global_transform.x.normalized().dot((enemy.global_position - global_position).normalized())))
		return angle <= degree
	return false
## Returns if weapon is pointing towards any enemy TODO: not setup
func IsAimingAtAnyEnemy() -> bool:
	if false: #TODO: setup with raycasts
		return true
	return false
## ItemData methods:
func set_stats() -> void:
	stats.connect_changed_signal(apply_stats)
func setdata():
	pass
func getdata() -> ItemData:
	return data
func get_stats():
	return stats
## Creates an ItemData.LevelUpgrade for this specific component and returns it once setup
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade] = super(itemdata)
	## 50% chance to be zero range increase
	arr.append(get_stat_upgrade(StatsResource.RANGE, randf_range(10, 25), itemdata.level, get_weighted_rarity(itemdata.level), 0, 0.1))
	return arr
## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var ret = super(itemdata)
	set_stat_randomize(ret, StatsResource.RANGE, randf_range(-5, 15), 0.01, 0)
	return ret
