extends Node

@onready var player: Player_Script = get_tree().get_first_node_in_group("player")
@onready var enemy = preload("res://Scenes/first_enemy.tscn")
@onready var sword = preload("res://Scenes/sword.tscn")
@onready var gun = preload("res://Scenes/LazarGun.tscn")

var projectile_cost = 10
var sword_cost = 2
var gun_cost = 4
var size_cost = 10

func _ready() -> void:
	player.current_money = 5

func _process(delta: float) -> void:
	
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
		pass#weapon_size += 0.5
	
	if Input.is_action_just_pressed("test_5"):
		player.is()
		pass#weapon_projectile_count += 1


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
