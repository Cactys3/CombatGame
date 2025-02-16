extends Node2D

@onready var player: Player_Script = get_tree().get_first_node_in_group("player")
@onready var enemy = preload("res://Scenes/first_enemy.tscn")
@onready var sword = preload("res://Scenes/sword.tscn")
@onready var gun = preload("res://Scenes/LazarGun.tscn")
@onready var shop: Panel = $"../Camera/Store"
@onready var xp = preload("res://Scenes/xp_blip.tscn")
@onready var weapon_frame = preload("res://Scenes/weapon_frame.tscn")
var LUGER_BULLET:PackedScene = preload("res://Scenes/luger_bullet.tscn")
var PISTOL_ATTACHMENT = preload("res://Scenes/pistol/pistol_attachment.tscn")
var PISTOL_HANDLE = preload("res://Scenes/pistol/pistol_handle.tscn")
var SWORD_ATTACHMENT = preload("res://Scenes/sword/sword_attachment.tscn")
var SWORD_HANDLE = preload("res://Scenes/sword/sword_handle.tscn")
var projectile_cost = 10
var sword_cost = 2
var gun_cost = 4
var size_cost = 10
var can_access_menus:bool = false

var list: Array[Weapon_Frame]

var current_difficulty:float = 1

enum scene_states{shop, combat, encounter}
var scene_state: scene_states = scene_states.shop

func _ready() -> void:
	player.current_money = 5

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") && can_access_menus:
		shop.visible = !shop.visible
	
	if Input.is_action_just_pressed("test_2"):
		var random_position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		var new_enemy = enemy.instantiate()
		new_enemy.position = random_position 
		add_child(new_enemy)
	
	if Input.is_action_just_pressed("test_1"):
		var new_weapon:Weapon = sword.instantiate()
		new_weapon.position = Vector2(0, 0)
		player.add_weapon(new_weapon)
	
	if Input.is_action_just_pressed("test_3"):
		var new_weapon:Weapon = gun.instantiate()
		new_weapon.position = Vector2(0, 0)
		player.add_weapon(new_weapon)

	if Input.is_action_just_pressed("test_4"):
		var new_frame = weapon_frame.instantiate()
		var new_attachment = PISTOL_ATTACHMENT.instantiate()
		var new_handle = PISTOL_HANDLE.instantiate()
		new_frame.stats = new_frame.stats.duplicate() #TODO: this is important, needs to be done whenever instantiating
		new_attachment.stats = new_attachment.stats.duplicate()
		new_handle.stats = new_handle.stats.duplicate()
		new_handle.position = Vector2.ZERO
		new_attachment.position = Vector2.ZERO
		new_frame.position = Vector2.ZERO
		new_frame.add_attachment(new_attachment)
		new_frame.add_handle(new_handle)
		new_frame.set_projectile(LUGER_BULLET)
		player.add_frame(new_frame)
		list.append(new_frame)
		
		new_attachment.get_child(0).self_modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), randf_range(0.2, 1))
		new_handle.get_child(0).self_modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), randf_range(0.2, 1))

	if Input.is_action_just_pressed("test_6"):
		var new_frame = weapon_frame.instantiate()
		var new_attachment = SWORD_ATTACHMENT.instantiate()
		var new_handle = SWORD_HANDLE.instantiate()
		new_frame.stats = new_frame.stats.duplicate() #TODO: this is important, needs to be done whenever instantiating
		new_attachment.stats = new_attachment.stats.duplicate()
		new_handle.stats = new_handle.stats.duplicate()
		new_frame.name = "Weapon_Frame_" + str(list.size())
		new_attachment.name = "Weapon_Attachment_" + str(list.size())
		new_handle.name = "Weapon_Handle_" + str(list.size())
		new_handle.position = Vector2.ZERO
		new_attachment.position = Vector2.ZERO
		new_frame.position = Vector2.ZERO
		new_frame.add_attachment(new_attachment)
		new_frame.add_handle(new_handle)
		new_frame.set_projectile(LUGER_BULLET)
		player.add_frame(new_frame)
		list.append(new_frame)
		#print(new_frame.stats.get_instance_id())
		
		new_attachment.get_child(0).self_modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), randf_range(0.2, 1))
		new_handle.get_child(0).self_modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), randf_range(0.2, 1))
		
		#for i in list:
		#	print(i.name)
		#	print(i.handle.stats.get_list_of_affection())
		#	print(i.attachment.stats.get_list_of_affection())
		#	print(" ")

	if Input.is_action_just_pressed("test_5"):
		if list.size() >= 2:
			var one = randi_range(0, list.size() - 1)
			var two = randi_range(0, list.size() - 1)
			while (one == two):
				two = randi_range(0, list.size() - 1)
			if (randi_range(0, 1) == 0):
				var a0 = list[one].remove_attachment()
				var a1 = list[two].remove_attachment()
				list[one].add_attachment(a1)
				list[two].add_attachment(a0)
			else:
				var a2 = list[one].remove_handle()
				var a3 = list[two].remove_handle()
				list[one].add_handle(a3)
				list[two].add_handle(a2)
		pass#weapon_projectile_count += 1

	if Input.is_action_just_pressed("test_7"):
		var random_position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		var new_xp = xp.instantiate()
		new_xp.position = random_position
		add_child(new_xp)
		#zach put this mowow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow mow
		pass#weapon_projectile_count += 1

func change_state(state: scene_states) -> void:
	match state:
		scene_states.shop:
			shop.visible = true
		scene_states.combat:
			shop.visible = false
		scene_states.encounter:
			shop.visible = false
		_:
			pass

func start_round(difficulty: float) -> void:
	#start spawner spawning enemies
	#maybe enemies are of said difficulty OR number of enemies are of said difficulty
	#(at a certian point into the round) random chance to spawn a boss of said difficulty (increases the longer there is no boss)
	pass

func toggle_shop(boolean: bool):
	shop.visible = boolean

func Projectile_Buttton() -> void:
	pass
	#if projectile_cost <= player.current_money:
	#	player.current_money -= projectile_cost
	#	for weapon in player.weapon_list:
	#		if weapon is Ranged_Weapon:
	#			weapon.weapon_projectile_count += 1

func Size_Button() -> void:
	if size_cost <= player.current_money:
		player.current_money -= size_cost
		for weapon in player.weapon_list:
			weapon.weapon_size += 0.2

func Gun_Button() -> void:
	if gun_cost <= player.current_money:
		player.current_money -= gun_cost
		var new_weapon:Weapon = gun.instantiate()
		new_weapon.position = Vector2(0, 0)
		player.add_weapon(new_weapon)

func Sword_Button() -> void:
	if sword_cost <= player.current_money:
		player.current_money -= sword_cost
		var new_weapon:Weapon = sword.instantiate()
		new_weapon.position = Vector2(0, 0)
		player.add_weapon(new_weapon)
