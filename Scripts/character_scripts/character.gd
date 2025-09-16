extends CharacterBody2D
class_name Player_Script

@export var anim: AnimationPlayer
@export var StartingMoney: int = 5
@export var player_stats: StatsResource = StatsResource.new()
var stats_visual = null
@export var hp_regen:float = 0
@export var knockback_modifier:float = 1
@export var can_be_knockbacked:bool = true
@export var can_be_stunned:bool = true
var stunning:bool = false
var stun_time_left: float = 0
var moving: bool = false
var weapon_list: Array[Weapon_Frame]
var weapon_count: float = 0
var static_slot_count: int = 0
var at_mouse_count: int = 0
var spin_aim_count: int = 0
## level, xp, money managed and set by GameManager
var level: float:
	set(value):
		if value > level:
			on_level_up(value, level)
		level = value
var xp: float:
	set(value):
		if value > xp:
			on_gain_xp(value, xp)
		xp = value
var money: float:
	set(value):
		if value > money:
			on_gain_money(value, money)
		money = value
## speed, maxhealth, stance get by StatsResource
var health: int
var speed: float:
	get():
		return get_stat(StatsResource.MOVESPEED)
var maxhealth: float:
	get():
		return get_stat(StatsResource.HP)
var stance: float:
	get():
		return get_stat(StatsResource.STANCE)

func _ready() -> void:
	call_deferred("set_stats")
	call_deferred("make_stats_visual")

func make_stats_visual():
	stats_visual = load("res://Scenes/UI/stats_visual.tscn").instantiate()
	GameManager.instance.ui_man.tab_menu_parent.add_child(stats_visual)
	stats_visual.global_position = Vector2.ZERO#Vector2(-310, -20)
	stats_visual.set_stats(player_stats, "Player Stats")

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

func handle_moving(delta) -> void:
	var moving_state = moving
	var directionX := Input.get_axis("left", "right")
	moving = false
	if !stunning: ## Stun Time prevents the player from inputting movement commands, but doesn't change their current velocity
		var new_velocity: Vector2
		if directionX:
			new_velocity.x = round(directionX) * speed
			moving = true
		else:
			new_velocity.x = 0
		var directionY := Input.get_axis("up", "down")
		if directionY:
			new_velocity.y = round(directionY) * speed
			moving = true
		else:
			new_velocity.y = 0
		velocity = velocity.move_toward(new_velocity.normalized() * speed, delta * 7000)
	if (moving_state != moving):
		set_moving_animation(moving)
	
	#print(velocity)

func damage(attack: Attack):
	#print("damage player: " + str(attack.damage))
	var net_damage = attack.damage - stance
	if net_damage == 0:
		return
	
	GameManager.instance.hp -= net_damage
	if can_be_stunned && attack.stun != 0:
		stun_time_left += attack.stun
		stunning = true
	if can_be_knockbacked && attack.knockback != 0:
		#stun_time_left += 0.1
		#stunning = true
		call_deferred("set", "velocity", (global_position - attack.position).normalized() * attack.knockback * knockback_modifier)
		#print("Knockback: " + str((global_position - attack.position).normalized() * attack.knockback * knockback_modifier))
	if health <= 0:
		die()

func die():
	print("player died: " + str(health))

func add_frame(new_frame: Weapon_Frame):
	weapon_list.append(new_frame)
	var temp_count = weapon_count
	match new_frame.handle.AimType:
		Handle.AimTypes.StaticSlot:
			static_slot_count += 1
			temp_count = static_slot_count
			#print("Aim Type: StaticSlot, count: " + str(static_slot_count))
		Handle.AimTypes.AtMouse:
			at_mouse_count += 1
			temp_count = at_mouse_count
			#print("Aim Type: AtMouse, count: " + str(at_mouse_count))
		Handle.AimTypes.Unique:
			spin_aim_count += 1
			temp_count = spin_aim_count
			#print("Aim Type: Unique, count: " + str(unique_aim_count))
		_:
			weapon_count += 1
			temp_count = weapon_count
			#print("Aim Type: Default, count: " + str(weapon_count))
	var index: float = 0
	for weapon in weapon_list:
		if (weapon.handle.AimType == new_frame.handle.AimType):
			index += 1
			weapon.change_slot(index, temp_count)
	print("Add Weapon Frame: " + new_frame.name)
	player_stats.add_stats(new_frame.stats)
	stats_visual.refresh()
	new_frame.make_stats_visual(weapon_list.size())
	add_child(new_frame)

func remove_frame(frame_sought: Weapon_Frame) -> bool:
	if frame_sought && weapon_list.has(frame_sought):
		weapon_list.erase(frame_sought)
		var temp_count = weapon_count
		match frame_sought.handle.AimType:
			Handle.AimTypes.StaticSlot:
				static_slot_count -= 1
				temp_count = static_slot_count
			Handle.AimTypes.AtMouse:
				at_mouse_count -= 1
				temp_count = at_mouse_count
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
		frame_sought.delete_stats_visual()
		player_stats.remove_stats(frame_sought.stats)
		stats_visual.refresh()
		print("removed weapon: " + frame_sought.name)
		return true
	return false

func get_stat(stat: String) -> float:
	return player_stats.get_stat(stat)

func get_random_frame() -> Weapon_Frame:
	if weapon_list.size() > 0:
		return weapon_list.get(randi_range(0, weapon_list.size() - 1))
	else:
		return null

## funcs to be overriden for special character mechanics (or item mechanics)
func set_stats(): ## set_stats should call super()
	GameManager.instance.hp = maxhealth

func character_ability(number: int) -> void:
	print("ability " + str(number))

func on_level_up(new_level: float, old_level: float) -> void:
	pass

func on_gain_xp(new_xp: float, old_xp: float) -> void:
	pass

func on_gain_money(new_money: float, old_money: float) -> void:
	pass

func set_moving_animation(boolean: bool):
	if boolean && is_instance_valid(anim) && anim.has_animation("play"):
		anim.play("move")
