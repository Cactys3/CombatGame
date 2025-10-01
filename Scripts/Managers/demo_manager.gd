extends Node2D

@export var EnemyParent: Node2D

@onready var player: Player_Script = get_tree().get_first_node_in_group("player")
const grub = preload("res://Scenes/Enemies/Grub.tscn")
const jub = preload("res://Scenes/Enemies/Jub.tscn")
const flub = preload("res://Scenes/Enemies/Flub.tscn")
const thub = preload("res://Scenes/Enemies/Thub.tscn")
@export var shop: Panel
@onready var xp = preload("res://Scenes/Misc/xp_blip.tscn")
@onready var weapon_frame = preload("res://Scenes/Weapons/weapon_frame.tscn")
#var LUGER_BULLET:PackedScene = preload("res://Scenes/luger_bullet.tscn")
var PISTOL_PROJECTILE = preload("res://Scenes/Weapons/pistol/pistol_bullet.tscn")
var PISTOL_ATTACHMENT = preload("res://Scenes/Weapons/pistol/pistol_attachment.tscn")
var PISTOL_HANDLE = preload("res://Scenes/Weapons/pistol/pistol_handle.tscn")
var SWORD_PROJECTILE = preload("res://Scenes/Weapons/sword/sword_projectile.tscn")
var SWORD_ATTACHMENT = preload("res://Scenes/Weapons/sword/sword_attachment.tscn")
var SWORD_HANDLE = preload("res://Scenes/Weapons/sword/sword_handle.tscn")
const FLAMETHROWER_ATTACHMENT = preload("res://Scenes/Weapons/flamethrower/flamethrower_attachment.tscn")
const FLAMETHROWER_HANDLE = preload("res://Scenes/Weapons/flamethrower/flamethrower_handle.tscn")
const FIRE_PROJECTILE = preload("res://Scenes/Weapons/flamethrower/fire_projectile.tscn")
const RAILGUN_ATTACHMENT = preload("res://Scenes/Weapons/railgun/railgun_attachment.tscn")
const RAILGUN_HANDLE = preload("res://Scenes/Weapons/railgun/railgun_handle.tscn")
const RAILGUN_PROJECTILE = preload("res://Scenes/Weapons/railgun/railgun_projectile.tscn")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test_2"):
		var j: Enemy = jub.instantiate()
		var g: Enemy = grub.instantiate()
		var f: Enemy = flub.instantiate()
		var t: Enemy = thub.instantiate()
		EnemyParent.add_child(j)
		EnemyParent.add_child(g)
		EnemyParent.add_child(f)
		EnemyParent.add_child(t)
		j.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
		g.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
		f.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
		t.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))

	if Input.is_action_just_pressed("test_3"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(1).get_item())

	if Input.is_action_just_pressed("test_4"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(2).get_item())

	if Input.is_action_just_pressed("test_5"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(3).get_item())
		

	if Input.is_action_just_pressed("test_6"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(4).get_item())

	if Input.is_action_just_pressed("test_7"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(5).get_item())
