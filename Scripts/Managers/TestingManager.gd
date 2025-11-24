extends Node2D

@export var EnemyParent: Node2D

@onready var player: Character = get_tree().get_first_node_in_group("player")
const grub = preload("res://Scenes/Enemies/Grub.tscn")
const jub = preload("res://Scenes/Enemies/Jub.tscn")
const flub = preload("res://Scenes/Enemies/Flub.tscn")
const thub = preload("res://Scenes/Enemies/Thub.tscn")
@export var shop: Panel
@onready var xp = preload("res://Scenes/Misc/xp_blip.tscn")
@onready var weapon_frame = preload("res://Scenes/Weapons/weapon_frame.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		get_tree()
	
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
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(0).get_item())

	if Input.is_action_just_pressed("test_4"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(1).get_item())

	if Input.is_action_just_pressed("test_5"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(2).get_item())

	if Input.is_action_just_pressed("test_6"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(3).get_item())

	if Input.is_action_just_pressed("test_7"):
		GameManager.instance.add_weapon_to_player(ShopManager.get_weapon(4).get_item())
		
		
	## Formerly in Game Manager:
	
	var game_man: GameManager = GameManager.instance
	
	if Input.is_action_just_pressed("ability1") && game_man.ui_man.tab_menu_parent.visible == true:
		game_man.ui_man.shop.stock(3)
	
	if Input.is_action_just_pressed("ability2") && game_man.ui_man.tab_menu_parent.visible == true:
		game_man.ui_man.shop.reroll()
	
	if Input.is_action_just_pressed("ability3") && game_man.ui_man.tab_menu_parent.visible == true:
		game_man.money += 10
		game_man.ui_man.cheat_inventory.clear()
		for index in ShopManager.item_list.size():
			#print(index)
			game_man.ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_item(index)))
		for index in ShopManager.handle_list.size():
			game_man.ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_weapon(index)))
		for index in ShopManager.handle_list.size():
			game_man.ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_attachment(index)))
			game_man.ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_handle(index)))
			game_man.ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_projectile(index)))
	
	if Input.is_action_just_pressed("test_5") && game_man.ui_man.paused_for_tab:
		pass#ui_man.inventory.add(preload("res://Scripts/flamethrower_scripts/flamethrower_handle.gd").new())
	
	if Input.is_action_just_pressed("test_6") && game_man.ui_man.tab_menu_parent.visible == true:
		var test1 = ShopManager.make_itemUI(game_man.shop_man.get_rand_equipment())
		var test2 = ShopManager.make_itemUI(game_man.shop_man.get_rand_attachment())
		
		game_man.ui_man.shop.ui_add(test1)
		game_man.ui_man.shop.ui_add(test2)
