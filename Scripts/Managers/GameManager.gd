extends Node
class_name GameManager
const LEVEL_UP_SCREEN = preload("res://Scenes/UI/level_up_screen.tscn")
static var STATS_VISUAL = preload("res://Scenes/UI/stats_visual.tscn")
@onready var weapon_frame = preload("res://Scenes/Weapons/weapon_frame.tscn")
## Single Instance Object
static var instance: GameManager
## Managers
@export var ui_man: UIManager 
@export var shop_man: ShopManager
@export var player: Player_Script
@export var instance_man: InstanceManager
## Parents
@export var xp_parent: Node2D
@export var enemy_parent: Node2D
@export var weapon_parent: Node2D

var active_items: Array[Item]
var character_choice_stats: StatsResource = StatsResource.new()
var global_stats: StatsResource = StatsResource.new()

var xp_to_next_level: float = 100
var xp_gained_since_last_level: float = 0
var xp_modifier_per_level: float = 1.1
var xp_from_past_levels: float = 0
var starting_money: float = 15

var hp: float = 0:
	set(value):
		hp = value
		ui_man.set_hp(str(value))
		player.health = int(value)
var level: float = 0: ## level
	set(value): #TODO: maybe send to instancemanager and make game harder by level
		level = value
		ui_man.set_level(str(int(value)))
		player.level = value
	get(): # calculate level based on total xp
		return level 
var xp: float = 0: ## Current (total?) XP Gained
	set(value):
		if (xp < value):
			xp_gained_since_last_level += (value - xp)
		xp = value
		ui_man.set_xp(str(int(value)))
		while xp_gained_since_last_level > xp_to_next_level:
			xp_from_past_levels += xp_to_next_level
			xp_gained_since_last_level -= xp_to_next_level
			xp_to_next_level *= xp_modifier_per_level
			level += 1
			emit_signal("level_up")
			print("Gained Level Costing: " + str(int(xp_to_next_level)) + " XP Leftover: " + str(int(xp_gained_since_last_level) - int(xp_to_next_level)))
		player.xp = value
	get():
		return xp
var money: float = 0: ## Current Money Held
	set(value):
		money = value
		ui_man.set_money(str(value))
		player.money = value
## TODO: Heiarchy of pausable menus that overwrite each other. EX: if esc menu is active, everything else is paused, even if level up screen is happening, it is paused
var paused: bool = false ## Is Game Instance Paused or Not
var paused_for_esc: bool = false
var paused_for_tab: bool = false
var paused_for_level_up: bool = false
var paused_for_shop: bool = false
var level_up_queue: int = 0
var leveling_up: bool = false
## Signals
# For GameManager Systems
signal pause_game(value: bool)
signal level_up()
# For UI Methods
signal toggle_inventory() #TODO: add bool value to keep track of toggle state?
signal toggle_esc()
signal set_xp(value: float)
signal set_money(value: float)
signal set_level(value: float)
signal set_hp(value: float)
signal add_item_to_player_inventory(item: Item)
# For Item Mechanics
signal EnemyDamaged(enemy: Enemy, attack: Attack)
signal EnemyKilled(enemy: Enemy, attack: Attack)
signal BossKilled(boss: Boss, attack: Attack)
signal PlayerDamaged(player: Player_Script, attack: Attack)
signal PlayerKilled(player: Player_Script, attack: Attack)
signal RoundEnded(round_number: int)

func _ready() -> void:
	# Ensure only one instance exists
	if instance != null:
		printerr("Error: Only one instance of gamemanager is allowed in the scene!")
		queue_free() 
		return
	instance = self  
	call_deferred("@level_setter", 0)
	call_deferred("@xp_setter", 0)
	call_deferred("@money_setter", starting_money)
	call_deferred("global_stats_visual")
	global_stats.add_stats(character_choice_stats)
	player.player_stats.add_stats(global_stats)
	
	connect("level_up", create_level_up_instance)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func global_stats_visual():
	var s = STATS_VISUAL.instantiate()
	ui_man.tab_menu_parent.add_child(s)
	s.global_position = Vector2(-310, -0)
	s.set_stats(global_stats, "Global Stats")

## Just handles inputs for testing right now
func _process(_delta: float) -> void:
	
	if !leveling_up && level_up_queue > 0:
		create_level_up_instance()
	
	if Input.is_action_just_pressed("ability1") && ui_man.tab_menu_parent.visible == true:
		ui_man.shop.stock(3)
	
	if Input.is_action_just_pressed("ability2") && ui_man.tab_menu_parent.visible == true:
		ui_man.shop.reroll()
	
	if Input.is_action_just_pressed("ability3") && ui_man.tab_menu_parent.visible == true:
		money += 10
		ui_man.cheat_inventory.clear()
		for index in ShopManager.handle_list.size():
			ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_weapon(index)))
		for index in ShopManager.handle_list.size():
			ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_attachment(index)))
			ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_handle(index)))
			ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_projectile(index)))
		ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_rand_item()))
		ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_rand_item()))
		ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_rand_item()))
		ui_man.cheat_inventory.new_add(ShopManager.make_itemUI(ShopManager.get_rand_item()))

	
	if Input.is_action_just_pressed("test_5") && ui_man.paused_for_tab:
		pass#ui_man.inventory.add(preload("res://Scripts/flamethrower_scripts/flamethrower_handle.gd").new())
	
	if Input.is_action_just_pressed("test_6") && ui_man.tab_menu_parent.visible == true:
		var test1 = ShopManager.make_itemUI(shop_man.get_rand_equipment())
		var test2 = ShopManager.make_itemUI(shop_man.get_rand_attachment())
		
		ui_man.shop.ui_add(test1)
		ui_man.shop.ui_add(test2)

func pause(value: bool):
	if paused != value:
		paused = value
		emit_signal("pause_game", value)
		if paused:
			#Engine.time_scale = 1.0
			get_tree().paused = true
		else:
			#Engine.time_scale = 0.0
			get_tree().paused = false

## Handles Money Part of Selling item (maybe supposed to expand this)
func sell_item(item: ItemData) -> bool:
	if (item && item.can_sell):
		money += item.item_buy_cost * item.item_sell_cost_modifier
		return true
	return false
## Handles Money Part of Buying item (maybe supposed to expand this)
func buy_item(item: ItemData) -> bool:
	if (item && (money > item.item_buy_cost)):
		money -= item.item_buy_cost
		return true
	return false
## Activates Item (equipment item)
func add_item_to_player(item: Item) -> bool:
	if (item):
		active_items.append(item)
		return true #TODO: add
	print("add: " + str(is_instance_valid(item)))
	return false

func remove_item_from_player(item: Item) -> bool:
	if item && active_items.has(item):
		active_items.erase(item)
		return true #TODO: remove
	return false

func remove_weapon_from_player(weapon: Weapon_Frame) -> bool:
	#if weapon && weapon.is_ready:
		#if !weapon.frame_ready:
			#weapon.make_frame()
		#if player.remove_frame(weapon.weapon):
			#weapon.equipped = false
			#return true
	#return false
	if player.remove_frame(weapon): 
		return true
	return false

func craft_weapon(handle: ItemUI, attachment: ItemUI, projectile: ItemUI) -> bool:
	if (handle && attachment && projectile) && (handle.data.item_type == ItemData.item_types.handle && attachment.data.item_type == ItemData.item_types.attachment && projectile.data.item_type == ItemData.item_types.projectile):
		
		var data: ItemData = ItemData.new()
		data.setup(false, ShopManager.random_rarity())
		data.set_components(attachment.data, handle.data, projectile.data)
		var weapon: Weapon_Frame = data.get_item()
		
		if add_weapon_to_player(weapon): #TODO: if player can hold more weapons
			ui_man.equipment.new_add(ShopManager.make_itemUI(data))
			return true
	return false

func add_weapon_to_player(weapon: Weapon_Frame) -> bool:
	if !weapon:
		return false
	player.add_frame(weapon)
	return true

# Inventory System Methods:
## Check if item can be removed and can be added, then does so
func move_item(item: ItemUI, origin: Inventory, destination: Inventory) -> bool:
	if item && destination && destination.can_add(item) && (!origin || (origin && origin.can_remove(item))):
		var complete_move: bool = true
		var remove_origin: bool = true
		var add_destination: bool = true
		var money_net_change = 0.0
		if !origin:
			remove_origin = false # Skip if adding new Item not already in an inventory
		else:
			match(origin.get_type()):
				Inventory.STORAGE:
					pass
				Inventory.EQUIPMENT:
					match(item.data.item_type):
						ItemData.item_types.weapon:
							if !remove_weapon_from_player(item.data.get_item()):
								complete_move = false
								return false
						ItemData.item_types.item:
							if !remove_item_from_player(item.data.get_item()):
								complete_move = false
								return false
						_:
							pass
				Inventory.SHOP:
					money_net_change += -item.data.item_buy_cost
				_:
					pass
		match(destination.get_type()):
			Inventory.STORAGE:
				pass
			Inventory.EQUIPMENT:
				match(item.data.item_type):
					ItemData.item_types.weapon:
						print("weapon!")
						if !add_weapon_to_player(item.data.get_item()):
							print("!add_weapon_to_player")
							complete_move = false
							return false
					ItemData.item_types.item:
						if !add_item_to_player(item.data.get_item()): ## TODO: new implementation: if !add_item_to_player(item.data.create_item()):
							print("!add_item_to_player")
							complete_move = false
							return false
					_:
						pass
			Inventory.SHOP:
				money_net_change += item.data.item_buy_cost * item.data.item_sell_cost_modifier
		if complete_move:
			money += money_net_change
			if remove_origin:
				origin.new_remove(item)
			if add_destination:
				destination.new_add(item)
			return true
	return false

## Checks if item can be removed, then removes it, used for moving items to non-inventories
func remove_item(item: ItemUI, origin: Inventory) -> bool:
	if item && origin && origin.can_remove(item):
		match(origin.get_type()):
			Inventory.STORAGE:
				pass
			Inventory.EQUIPMENT:
				match(item.data.item_type):
					ItemData.item_types.weapon:
						remove_weapon_from_player(item.data.get_item())
					ItemData.item_types.item:
						remove_item_from_player(item.data.get_item())
					_:
						pass
			Inventory.SHOP:
				pass
		origin.new_remove(item)
		return true
	return false

func can_buy(price: float) -> bool:
	return price <= money

func can_equip(item: ItemUI) -> bool:
	## Check if its a weapon or item, Check if there is room for weapon, etc..
	return item.data.item_type == ItemData.item_types.weapon || item.data.item_type == ItemData.item_types.item

func can_unequip(item: ItemUI) -> bool:
	return true ## Check if player has weapon equipped

func create_level_up_instance():
	if leveling_up:
		level_up_queue += 1
		return
	leveling_up = true
	ui_man.pause_level_up()
	## get 3 random things w/ variable references
	var one = LevelUpData.get_random_level_up_option()
	var two = LevelUpData.get_random_level_up_option()
	var three = LevelUpData.get_random_level_up_option()
	## setup LevelUpInstance with those random things and their details (color, name, etc)
	var instance = LEVEL_UP_SCREEN.instantiate()
	instance.global_position = Vector2.ZERO
	ui_man.level_up_parent.add_child(instance)
	instance.setup(1, one)
	instance.setup(2, two)
	instance.setup(3, three)
	var choice: LevelUpData = await instance.get_choice()
	choice.carryout_level_up()
	instance.free_instance()
	ui_man.pause_level_up()
	level_up_queue -= 1
	leveling_up = false

func get_random_equipped_weapon():
	return player.get_random_frame()
func get_random_equipped_item():
	if active_items.size() > 0:
		return active_items.get(randi_range(0, active_items.size() - 1))
	else:
		return null
