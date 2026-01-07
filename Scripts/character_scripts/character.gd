extends CharacterBody2D
class_name Character

@export var character_name: String = "Character"
@export var anim: AnimationPlayer
@export var StartingMoney: int = 5
@export var player_stats: StatsResource = StatsResource.BLANK_STATS.duplicate()

@export var hp_regen:float = 0
@export var knockback_modifier:float = 1
@export var can_be_knockbacked:bool = true
@export var can_be_stunned:bool = true
## States
var stunning:bool = false
var stun_time_left: float = 0
var moving: bool = false
## Weapons
var weapon_list: Array[Weapon_Frame]
var weapon_count: int = 0
var static_slot_count: int = 0
var dynamic_at_mouse_count: int = 0
var always_at_mouse_count: int = 0
var spin_aim_count: int = 0
## Current Variables
var curr_speed: float
## Stat Variables
var maxspeed: float:
	get():
		return get_stat(StatsResource.MOVESPEED)
var maxhealth: float:
	get():
		return get_stat(StatsResource.HP) 
var maxshield: float:
	get():
		return get_stat(StatsResource.SHIELD)
var stance: float:
	get():
		return get_stat(StatsResource.STANCE)
var size: float:
	get():
		return get_stat(StatsResource.SIZE)
var xp_gain: float:
	get():
		return get_stat(StatsResource.XP)
var money_gain: float:
	get():
		return get_stat(StatsResource.MOGUL)

func _ready() -> void:
	pass
func initialize_stats() -> void:
	GameManager.instance.hp = maxhealth
	GameManager.instance.shield = maxshield
	curr_speed = maxspeed
	stat_changed_method()
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ability1"):
		character_ability(1)
	if Input.is_action_just_pressed("ability2"):
		character_ability(2)
	if Input.is_action_just_pressed("ability3"):
		character_ability(3)
func _physics_process(_delta: float) -> void:
	if stun_time_left > 0:
		stun_time_left -= _delta 
	else:
		stunning = false
	handle_moving(_delta)
	move_and_slide()
	handle_regens(_delta)
func handle_regens(delta) -> void:
	if GameManager.instance.shield < maxshield:
		GameManager.instance.shield += 5 * delta
	if hp_regen > 0 && GameManager.instance.hp < maxhealth:
		GameManager.instance.hp += hp_regen * delta
func handle_moving(delta) -> void:
	var moving_state = moving
	var directionX := Input.get_axis("left", "right")
	moving = false
	if !stunning: ## Stun Time prevents the player from inputting movement commands, but doesn't change their current velocity
		var new_velocity: Vector2
		if directionX:
			new_velocity.x = round(directionX) * curr_speed
			moving = true
		else:
			new_velocity.x = 0
		var directionY := Input.get_axis("up", "down")
		if directionY:
			new_velocity.y = round(directionY) * curr_speed
			moving = true
		else:
			new_velocity.y = 0
		velocity = velocity.move_toward(new_velocity.normalized() * curr_speed, delta * 7000)
	if (moving_state != moving):
		set_moving_animation(moving)
	
	#print(velocity)
func damage(attack: Attack):
	## Consider Stance
	var net_damage = attack.damage - stance
	## Consider Sheild
	if net_damage > 0 && GameManager.instance.shield > 0:
		if (GameManager.instance.shield > net_damage):
			GameManager.instance.shield -= net_damage
			net_damage = 0
		else:
			net_damage -= GameManager.instance.shield
			GameManager.instance.shield = 0
	## Consider HP
	if net_damage > 0:
		GameManager.instance.hp -= net_damage
	## Consider Stun
	if can_be_stunned && attack.stun != 0:
		stun_time_left += attack.stun
		stunning = true
	## Consider Knockback
	if can_be_knockbacked && attack.knockback != 0:
		call_deferred("set", "velocity", (global_position - attack.position).normalized() * attack.knockback * knockback_modifier)
	if GameManager.instance.hp <= 0:
		die()
func die():
	pass#print("player died: " + str(health))
func add_frame(new_frame: Weapon_Frame):
	weapon_list.append(new_frame)
	var temp_count = weapon_count
	match new_frame.handle.AimType:
		Handle.AimTypes.StaticSlot:
			static_slot_count += 1
			temp_count = static_slot_count
		Handle.AimTypes.DynamicAtMouse:
			dynamic_at_mouse_count += 1
			temp_count = dynamic_at_mouse_count
		Handle.AimTypes.AlwaysAtMouse:
			always_at_mouse_count += 1
			temp_count = always_at_mouse_count
		Handle.AimTypes.Unique:
			spin_aim_count += 1
			temp_count = spin_aim_count
		_:
			weapon_count += 1
			temp_count = weapon_count
	var index: float = 0
	for weapon in weapon_list:
		if (weapon.handle.AimType == new_frame.handle.AimType):
			index += 1
			weapon.change_slot(index, temp_count)
	player_stats.add_stats(new_frame.stats)
	#new_frame.make_stats_visual(weapon_list.size())
	if new_frame.get_parent():
		call_deferred("reparent", new_frame)
	else:
		call_deferred("add_child", new_frame)

func remove_frame(frame_sought: Weapon_Frame) -> bool:
	if frame_sought && weapon_list.has(frame_sought):
		weapon_list.erase(frame_sought)
		var temp_count = weapon_count
		match frame_sought.handle.AimType:
			Handle.AimTypes.StaticSlot:
				static_slot_count -= 1
				temp_count = static_slot_count
			Handle.AimTypes.DynamicAtMouse:
				dynamic_at_mouse_count -= 1
				temp_count = dynamic_at_mouse_count
			Handle.AimTypes.AlwaysAtMouse:
				always_at_mouse_count -= 1
				temp_count = always_at_mouse_count
			Handle.AimTypes.Unique:
				spin_aim_count -= 1
				temp_count = spin_aim_count
			_:
				weapon_count -= 1
				temp_count = weapon_count
		var index: float = 0
		for weapon in weapon_list:
			if (weapon.handle.AimType == frame_sought.handle.AimType):
				index += 1
				weapon.change_slot(index, temp_count)
		remove_child(frame_sought)
		player_stats.remove_stats(frame_sought.stats)
		return true
	return false
func get_stat(stat: String) -> float:
	return player_stats.get_stat(stat)
func get_random_frame() -> Weapon_Frame:
	if weapon_list.size() > 0:
		return weapon_list.get(randi_range(0, weapon_list.size() - 1))
	else:
		return null
## func reapplies all affects that stats have based on newly checked values
func stat_changed_method():
	# hp, size, xp gain, money gain, etc
	transform.scaled(Vector2(size, size))
	GameManager.instance.hp = GameManager.instance.hp ## checks maxhp to setup UI properly
	GameManager.instance.shield = GameManager.instance.shield ## checks maxshield to setup UI properly
func character_ability(number: int) -> void:
	pass#print("ability " + str(number))
func on_level_up(new_level: float, old_level: float) -> void:
	pass
func on_gain_xp(new_xp: float, old_xp: float) -> void:
	pass
func on_gain_money(new_money: float, old_money: float) -> void:
	pass
func set_moving_animation(boolean: bool):
	if boolean && is_instance_valid(anim) && anim.has_animation("play"):
		anim.play("move")
