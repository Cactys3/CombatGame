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
@export var projectile_parent: Node2D
@export var extra_stats_visual: StatsDisplay

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
var xp_gain_modifier: float:
	get():
		print(max(0.1, 1 + (player.xp_gain - 1) / 100))
		return max(0.1, 1 + (player.xp_gain - 1) / 100)
var money_gain_modifier: float:
	get():
		return max(0.1, 1 + (player.money_gain - 1) / 100)

var max_hp: float:
	get():
		return player.maxhealth
var max_shield: float:
	get():
		return player.maxshield
var shield: float = 0:
	set(value):
		shield = value
		if max_shield > 0:
			ui_man.set_shield(str(value), value / max_shield)
		else:
			ui_man.set_shield("0", 0)
var hp: float = 0:
	set(value):
		hp = value
		if max_hp > 0:
			ui_man.set_hp(str(value), hp / max_hp)
		else:
			ui_man.set_hp(str(value), 0)
var level: float = 1: ## level
	set(value): #TODO: maybe send to instancemanager and make game harder by level
		level = value
		ui_man.set_level(str(int(value)))
	get(): # calculate level based on total xp
		return level 
var xp: float = 0: ## Current (total?) XP Gained
	set(value):
		var xp_just_added: float = 0
		if (value > xp): ## Factor in xp_gain only when adding xp, not subtracting xp
			xp_just_added = (value - xp) * xp_gain_modifier
		else:
			xp_just_added = (value - xp) 
		xp_gained_since_last_level += (xp_just_added)
		xp = xp + xp_just_added
		ui_man.set_xp(str(int(xp)), xp_gained_since_last_level / xp_to_next_level)
		while xp_gained_since_last_level > xp_to_next_level:
			xp_from_past_levels += xp_to_next_level
			xp_gained_since_last_level -= xp_to_next_level
			xp_to_next_level *= xp_modifier_per_level
			level += 1
			emit_signal("level_up")
			#print("Gained Level Costing: " + str(int(xp_to_next_level)) + " XP Leftover: " + str(int(xp_gained_since_last_level) - int(xp_to_next_level)))
var money: float = 0: ## Current Money Held
	set(value):
		if value > money: ## Factor in money_gain when adding money
			#print("new money: " + str((value - money)) + " * " + str(money_gain_modifier))
			money = money + (value - money) * money_gain_modifier
		else:
			money = value
		ui_man.set_money(money)
var difficulty: float:
	get():
		return player.player_stats.get_stat(StatsResource.DIFFICULTY)
var luck: float:
	get():
		return player.player_stats.get_stat(StatsResource.LUCK)

var paused: bool = false ## Is Game Instance Paused or Not
var level_up_queue: int = 0
var leveling_up: bool = false
## Signals
## For GameManager Systems
signal pause_game(value: bool)
signal level_up()
## For UI Methods
signal toggle_inventory() #TODO: add bool value to keep track of toggle state?
signal toggle_esc()
signal set_xp(value: float)
signal set_money(value: float)
signal set_level(value: float)
signal set_hp(value: float)
signal add_item_to_player_inventory(item: Item)
## For Item Mechanics
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
	EnemyKilled.connect(enemy_killed)
	PlayerDamaged.connect(player_damaged)
func setup_deffered(starting_weapon: int):
	player.player_stats.setup(player.character_name)
	player.player_stats.connect_changed_signal(player.stat_changed_method)
	player.player_stats.add_stats(global_stats)
	player.initialize_stats()
	level = 1
	xp = 0
	money = starting_money
	get_tree().paused = false
	var s: Array[StatsResource]
	player.player_stats.External_GetAllStatsRecursive(s)
	for stat in player.player_stats.External_GetAllStatsRecursive(s):
		stat.get_stat(StatsResource.DAMAGE)
	ui_man.AIOman.set_character_stats_display(player.player_stats)
	call_deferred("setup_weapon", starting_weapon)
## It's Necessary to deferr this twice as it relies on stuff that is deferred once to happen (i don't know what exactly it relies on)
func setup_weapon(starting_weapon: int):
	var weapon: ItemData = ShopManager.get_weapon(starting_weapon)
	## Starting weapon shouldn't give free forge, right?
	weapon.can_dismantle = false
	if !ui_man.equipment.ui_add(ShopManager.make_itemUI(weapon)):
		add_weapon_to_player(weapon.get_item())
		ui_man.equipment.backend_add(ShopManager.make_itemUI(weapon))
func _ready() -> void:
	# Ensure only one instance exists
	if instance != null:
		printerr("Error: Only one instance of gamemanager is allowed in the scene!")
		queue_free() 
		return
	instance = self  
var test: bool = false
func _process(_delta: float) -> void:
	if !test:
		test = true
		var node = load("uid://ceycsndkpdg1t").instantiate()
		xp_parent.add_child(node)
		node.position = node.position + Vector2(0, -110)
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
		money += item.get_cost(true)
		return true
	return false
## Handles Money Part of Buying item (maybe supposed to expand this)
func buy_item(item: ItemData) -> bool:
	if (item && (money >= item.get_cost(false))):
		money -= item.get_cost(false)
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
					money_net_change += -item.get_cost(false)
		if destination.get_type() == Inventory.EQUIPMENT:
			if item.data.item_type == ItemData.item_types.weapon:
				add_weapon_to_player(item.data.get_item())
			elif item.data.item_type == ItemData.item_types.item:
				add_item_to_player(item.data.get_item())
		elif destination.get_type() == Inventory.EQUIPMENT:
			money_net_change += item.get_cost(true)
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
	var level_pause: UIManager.PauseItem = UIManager.PauseItem.new(Callable(), UIManager.PauseItem.PauseTypes.ui, false, false, ui_man.level_up_parent)
	ui_man.pause(level_pause)
	## get 3 random things w/ variable references
	var array: Array[LevelUpData] = []
	var one = LevelUpData.get_random_level_up_option(array)
	array.append(one)
	var two = LevelUpData.get_random_level_up_option(array)
	array.append(two)
	var three = LevelUpData.get_random_level_up_option(array)
	array.append(three)
	## setup LevelUpInstance with those random things and their details (color, name, etc)
	var level_instance = LEVEL_UP_UI.instantiate()
	level_instance.set_pause(level_pause)
	#level_instance.position = Vector2(0, 0)
	ui_man.level_up_parent.add_child(level_instance)
	level_instance.add_choice(one)
	level_instance.add_choice(two)
	level_instance.add_choice(three)
	var choice: LevelUpData = await level_instance.get_choice()
	choice.carryout_level_up()
	level_instance.free_instance()
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
func add_xp(added_xp: float):
	xp += added_xp
## Signal Connections
func enemy_killed(enemy: Enemy, attack: Attack):
	if player.lifesteal > 0 && hp < max_hp:
		hp += player.lifesteal
func player_damaged(playah: Character, attack: Attack):
	if attack.attacker != null && player.thorns > 0 && attack.attacker.has_method("damage"):
		attack.attacker.damage(Attack.new(player.thorns, player.position, 0, null, null, 0, 0, 0))
func get_forge() -> ItemUI:
	for item: ItemUI in ui_man.inventory.items:
		if item.data.item_type == ItemData.item_types.item && item.data.get_item().is_forge():
			return item
	return null
func has_item_room():
	return item_count <= item_limit
func has_weapon_room():
	return weapon_count <= weapon_limit

func get_random_equipped_weapon() -> ItemData:
	return player.get_random_frame().data
func get_random_equipped_comp() -> ItemData:
	var frame: Weapon_Frame = player.get_random_frame()
	if frame:
		match(randi_range(1, 3)):
			1: 
				return frame.attachment.data
			2:
				return frame.handle.data
			3:
				return frame.projectile.data
	return null
func get_random_equipped_item() -> ItemData:
	if active_items.size() > 0:
		return active_items.get(randi_range(0, active_items.size() - 1)).data
	else:
		return null
func get_random_equipped_comp_except(avoided_items: Array[ItemData]) -> ItemData:
	var comps: Array[ItemData] = get_all_equipped_components()
	## Randomize Order
	comps.shuffle()
	for comp in comps:
		if !avoided_items.has(comp):
			return comp
	## Return null if all comps are avoided
	return null
func get_random_equipped_item_except(avoided_items: Array[ItemData]) -> ItemData:
	var items: Array[Item] = active_items.duplicate()
	items.shuffle()
	for item in items:
		if !avoided_items.has(item):
			return item.data
	return null
func get_all_equipped_components() -> Array[ItemData]:
	var frames: Array[Weapon_Frame] = player.weapon_list
	var comps: Array[ItemData] = []
	for frame in frames:
		comps.append(frame.attachment.data)
		comps.append(frame.handle.data)
		comps.append(frame.projectile.data)
	return comps
