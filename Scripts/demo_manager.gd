extends Node

@onready var player: Player_Script = get_tree().get_first_node_in_group("player")
@onready var enemy = preload("res://Scenes/first_enemy.tscn")
@onready var sword = preload("res://Scenes/sword.tscn")
@onready var gun = preload("res://Scenes/LazarGun.tscn")
@onready var shop: Panel = $"../Camera/Store"
@onready var xp = preload("res://Scenes/xp_blip.tscn")
@onready var weapon_frame = preload("res://Scenes/weapon_frame.tscn")
const LUGER_BULLET = preload("res://Scenes/luger_bullet.tscn")
const PISTOL_ATTACHMENT = preload("res://Scenes/pistol/pistol_attachment.tscn")
const PISTOL_HANDLE = preload("res://Scenes/pistol/pistol_handle.tscn")
var projectile_cost = 10
var sword_cost = 2
var gun_cost = 4
var size_cost = 10
var can_access_menus:bool = false

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
		new_frame.position = Vector2.ZERO
		player.add_child(new_frame)
		new_frame.set_attachment(PISTOL_ATTACHMENT)
		new_frame.set_handle(PISTOL_HANDLE)
		new_frame.set_projectile(LUGER_BULLET)
		print(LUGER_BULLET.resource_name)
		player.add_frame(new_frame)
		pass#weapon_size += 0.5
	
	if Input.is_action_just_pressed("test_5"):
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
	if projectile_cost <= player.current_money:
		player.current_money -= projectile_cost
		for weapon in player.weapon_list:
			if weapon is Ranged_Weapon:
				weapon.weapon_projectile_count += 1

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
