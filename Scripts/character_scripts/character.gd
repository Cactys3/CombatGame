extends CharacterBody2D
class_name Player_Script

@export var Speed: int = 210
@export var MaxHealth: int = 210
@export var StartingMoney: int = 5
var  CurrentHealth: int
var moving: bool = false
var stunned:bool = false
var stun_time_left: float = 0
var weapon_list: Array[Weapon_Frame]
var weapon_count: float = 0
var static_slot_count: int = 0
var at_mouse_count: int = 0
var unique_aim_count: int = 0
@onready var money_label: Label = $"../Camera/Store/Money Label/Money"
@onready var xp_label: Label = $"../Camera/Store/XP Label/XP"
@onready var level_label: Label = $"../Camera/Store/LVL Label/LVL"

var current_level: float = 0:
	set(value):
		current_level = value
		level_label.text = str(value)

var current_xp: float = 0:
	set(value):
		current_xp = value
		xp_label.text = str(value)

var max_xp :float = 100

var current_money: float = 0:
	set(value):
		#TODO: reorganize this into game manager instead
		current_money = value
		money_label.text = str(value)

func _ready() -> void:
	CurrentHealth = MaxHealth
	current_xp = 0
	current_level = 0


func _process(delta: float) -> void:
	if (current_xp >= max_xp):
		#TODO: tell game manager level up
		current_level += 1
		current_xp = 0
	
	if stun_time_left > 0:
		stun_time_left -= delta
		stunned = true
	elif stunned:
		stunned = false

func _physics_process(_delta: float) -> void:
	if stunned:
		moving = false
		#TODO:stunned/knockback animation
	else:
		handle_moving()
		if moving:
			moving = true #TODO: walk animation
	move_and_slide()

func handle_moving() -> void:
	var directionX := Input.get_axis("left", "right")
	if directionX:
		velocity.x = move_toward(velocity.x, directionX * Speed, 65)#directionX * SPEED
		moving = true
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, 100)	
		
	var directionY := Input.get_axis("up", "down")
	if directionY:
		velocity.y = move_toward(velocity.y, directionY * Speed, 65)#directionY * SPEED
		moving = true
	else:
		velocity.y = move_toward(velocity.y, 0, 100)

func damage(attack: Attack):
	print("damage player: " + str(attack.damage))
	CurrentHealth -=attack.damage
	if attack.stun > 0:
			stun_time_left = attack.stun
			velocity = Vector2.ZERO
	if attack.knockback != 0:
		if stun_time_left < 0.1:
			stun_time_left = 0
		call_deferred("set", "velocity", (global_position - attack.position).normalized() * attack.knockback)
	if CurrentHealth <= 0:
		die()
	pass

func die():
	print("player died")


func add_frame(new_frame: Weapon_Frame):
	#print("Weapon: " + str(weapon_count + 1) + " - " + new_weapon.name)
	weapon_list.append(new_frame)
	var temp_count = weapon_count
	match new_frame.handle.AimType:
		Handle.AimTypes.StaticSlot:
			static_slot_count += 1
			temp_count = static_slot_count
			print("Aim Type: StaticSlot, count: " + str(static_slot_count))
		Handle.AimTypes.AtMouse:
			at_mouse_count += 1
			temp_count = at_mouse_count
			print("Aim Type: AtMouse, count: " + str(at_mouse_count))
		Handle.AimTypes.Unique:
			unique_aim_count += 1
			temp_count = unique_aim_count
			print("Aim Type: Unique, count: " + str(unique_aim_count))
		_:
			weapon_count += 1
			temp_count = weapon_count
			print("Aim Type: Default, count: " + str(weapon_count))
	
	var index: float = 0
	for weapon in weapon_list:
		if (weapon.handle.AimType == new_frame.handle.AimType):
			index += 1
			weapon.change_slot(index, temp_count)
	print("Index: " + str(index))
	add_child(new_frame)
