extends CharacterBody2D
class_name Character

@export var character_name: String = "Character"
@export var pickup_range: CollisionShape2D
@export var anim: AnimatedSprite2D
@export var player_stats: StatsResource = StatsResource.BLANK_STATS.duplicate()
@export var knockback_modifier:float = 1
@export var can_be_knockbacked:bool = true
@export var can_be_stunned:bool = true
## Variables
var default_pickup_radius: float = 30
var regen_stopwatch: float = 0
var time_since_taken_damage: float = 0
var shield_cooldown: float = 3
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
		return StatsResource.calculate_movespeed(player_stats.get_stat(StatsResource.MOVESPEED))
var maxhealth: float:
	get():
		return player_stats.get_stat(StatsResource.HP) 
var maxshield: float:
	get():
		return player_stats.get_stat(StatsResource.SHIELD)
var stance: float:
	get():
		return player_stats.get_stat(StatsResource.STANCE)
var size: float:
	get():
		return player_stats.get_stat(StatsResource.SIZE)
var xp_gain: float:
	get():
		return player_stats.get_stat(StatsResource.XP)
var money_gain: float:
	get():
		return player_stats.get_stat(StatsResource.MOGUL)
var regen: float:
	get():
		return player_stats.get_stat(StatsResource.REGEN)
var lifesteal: float:
	get():
		return player_stats.get_stat(StatsResource.LIFESTEAL)
var thorns: float:
	get():
		return player_stats.get_stat(StatsResource.THORNS)
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
func _physics_process(delta : float) -> void:
	if stun_time_left > 0:
		stun_time_left -= delta
	else:
		stunning = false
	handle_moving(delta)
	move_and_slide()
	handle_regens(delta)
	time_since_taken_damage += delta
func handle_regens(delta) -> void:
	## Regen shield if hasn't taken damage in awhile
	if time_since_taken_damage >= shield_cooldown && GameManager.instance.shield < maxshield:
		GameManager.instance.shield += 5 * delta
	## Regen happens once every second
	regen_stopwatch += delta
	if regen_stopwatch >= 1:
		regen_stopwatch = 0
		if regen > 0 && GameManager.instance.hp < maxhealth:
			GameManager.instance.hp += StatsResource.calculate_regen(regen)
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
	if StatsResource.calculate_avoid_damage(player_stats.get_stat(StatsResource.GHOSTLY)):
		net_damage = 0
		print("PLAYER AVOIDED DAMAGE")
	if net_damage > 0:
		GameManager.instance.PlayerDamaged.emit(self, attack)
		time_since_taken_damage = 0
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
		GameManager.instance.PlayerKilled.emit(self, attack)
		die()
func die():
	pass#print("player died: " + str(health))
func add_frame(new_frame: Weapon_Frame):
	weapon_list.append(new_frame)
	var temp_count: int = weapon_count
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
	var index: int = 0
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
		var temp_count: int = weapon_count
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
		var index: int = 0
		for weapon in weapon_list:
			if (weapon.handle.AimType == frame_sought.handle.AimType):
				index += 1
				weapon.change_slot(index, temp_count)
		remove_child(frame_sought)
		player_stats.remove_stats(frame_sought.stats)
		return true
	return false
func get_random_frame() -> Weapon_Frame:
	if weapon_list.size() > 0:
		return weapon_list.get(randi_range(0, weapon_list.size() - 1))
	else:
		return null
## func reapplies all affects that stats have based on newly checked values
func stat_changed_method():
	# hp, size, xp gain, money gain, magentize etc
	pickup_range.shape.radius = default_pickup_radius + player_stats.get_stat(StatsResource.MAGNETIZE)
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
