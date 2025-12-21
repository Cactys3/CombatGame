extends Node
class_name GameManager

const LEVEL_UP_UI = preload("uid://cykl0goweao0i")

@onready var weapon_frame = preload("res://Scenes/Weapons/weapon_frame.tscn")

## Single Instance Object
static var instance: GameManager
## Managers
@export var ui_man: UIManager 
@export var shop_man: ShopManager
@export var player: Character
## Parents
@export var xp_parent: Node2D
@export var enemy_parent: Node2D
@export var weapon_parent: Node2D

var weapon_count: int:
	get():
		return player.weapon_count
	set(value):
		player.weapon_count = value
var weapon_limit: int = 10
var item_count: int:
	get():
		return active_items.size()
var item_limit: int = 10
var weapon_limit_reached: bool:
	get():
		return has_weapon_room()
var item_limit_reached: bool:
	get():
		return has_item_room()
var active_items: Array[Item]
var items_affecting_stats: Array[Item]
var global_stats: StatsResource

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
			#print("Gained Level Costing: " + str(int(xp_to_next_level)) + " XP Leftover: " + str(int(xp_gained_since_last_level) - int(xp_to_next_level)))
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
signal PlayerDamaged(player: Character, attack: Attack)
signal PlayerKilled(player: Character, attack: Attack)
signal RoundEnded(round_number: int)

func setup(new_player: Character, starting_weapon: int, new_global_stats: StatsResource):
	player = new_player
	call_deferred("setup_deffered", starting_weapon)
	connect("level_up", create_level_up_instance)
	process_mode = Node.PROCESS_MODE_ALWAYS
	global_stats = new_global_stats

func setup_deffered(starting_weapon: int):
	level = 0
	xp = 0
	money = starting_money
	player.player_stats.add_stats(global_stats)
	get_tree().paused = false
	var weapon: ItemData = ShopManager.get_weapon(starting_weapon)
	add_weapon_to_player(weapon.get_item())
	ui_man.equipment.backend_add(ShopManager.make_itemUI(weapon))

func _ready() -> void:
	# Ensure only one instance exists
	if instance != null:
		printerr("Error: Only one instance of gamemanager is allowed in the scene!")
		queue_free() 
		return
	instance = self  

func _process(_delta: float) -> void:
	if !leveling_up && level_up_queue > 0:
		create_level_up_instance()

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
## Activates Item 
func add_item_to_player(item: Item) -> void:
	active_items.append(item)
	item.enable()
## Equips Weapon
func add_weapon_to_player(weapon: Weapon_Frame) -> void:
	player.add_frame(weapon)
func remove_item_from_player(item: Item) -> void:
	item.disable()
	active_items.erase(item)
func remove_weapon_from_player(weapon: Weapon_Frame) -> void:
	player.remove_frame(weapon)
# Inventory System Methods:
## Check if item can be removed and can be added, then does so
func move_item(item: ItemUI, origin: Inventory, destination: Inventory) -> bool:
	if item && destination && destination.can_add(item) && (!origin || origin.can_remove(item)):
		var money_net_change = 0.0
		if origin:
			origin.backend_remove(item)
			if origin.get_type() == Inventory.EQUIPMENT:
				if item.data.item_type == ItemData.item_types.weapon:
					remove_weapon_from_player(item.data.get_item())
				elif item.data.item_type == ItemData.item_types.item:
					remove_item_from_player(item.data.get_item())
			elif origin.get_type() == Inventory.SHOP:
					money_net_change += -item.data.item_buy_cost
		if destination.get_type() == Inventory.EQUIPMENT:
			if item.data.item_type == ItemData.item_types.weapon:
				add_weapon_to_player(item.data.get_item())
			elif item.data.item_type == ItemData.item_types.item:
				add_item_to_player(item.data.get_item())
		elif destination.get_type() == Inventory.EQUIPMENT:
			money_net_change += item.data.item_buy_cost * item.data.item_sell_cost_modifier
		destination.backend_add(item)
		money += money_net_change
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
		origin.backend_remove(item)
		return true
	return false
func can_buy(price: float) -> bool:
	return price <= money
func can_equip(item: ItemUI) -> bool:
	## Check if its a weapon or item, Check if there is room for weapon, etc..
	return (weapon_count <= weapon_limit && item.data.item_type == ItemData.item_types.weapon) || (item_count <= item_limit && item.data.item_type == ItemData.item_types.item)
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
	var instance = LEVEL_UP_UI.instantiate()
	instance.global_position = Vector2(-42, -170)
	ui_man.level_up_parent.add_child(instance)
	instance.add_choice(one)
	instance.add_choice(two)
	instance.add_choice(three)
	var choice: LevelUpData = await instance.get_choice()
	choice.carryout_level_up()
	instance.free_instance()
	ui_man.pause_level_up()
	level_up_queue -= 1
	leveling_up = false
## Makes Item's Stats affect Global Stats
func add_stats_item(item: Item, stats: StatsResource):
	global_stats.add_stats(stats)
	items_affecting_stats.append(item)
## Removes Item's Stats from affecting Global Stats
func remove_stats_item(item: Item, stats: StatsResource):
	global_stats.remove_stats(stats)
	items_affecting_stats.erase(item)

func has_item_room():
	return item_count <= item_limit
func has_weapon_room():
	return weapon_count <= weapon_limit

func get_random_equipped_weapon() -> ItemData:
	return player.get_random_frame().data
func get_random_equipped_comp() -> ItemData:
	var frame: Weapon_Frame = player.get_random_frame()
	if frame:
		match(randf_range(1, 3)):
			1: 
				return frame.attachment.data
			2:
				return frame.handle.data
			_:
				return frame.projectile.data
	return null
func get_random_equipped_item():
	if active_items.size() > 0:
		return active_items.get(randi_range(0, active_items.size() - 1))
	else:
		return null
