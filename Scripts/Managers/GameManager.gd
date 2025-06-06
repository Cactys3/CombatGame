extends Node
class_name GameManager

@onready var weapon_frame = preload("res://Scenes/weapon_frame.tscn")

## Single Instance Object
static var instance: GameManager
## Managers
@export var ui_man: UIManager 
@export var shop_man: ShopManager
@export var instance_man: InstanceManager
@export var player: Player_Script
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

## Signals
# For UI Methods
signal toggle_inventory
signal set_xp(value: float)
signal set_money(value: float)
signal set_level(value: float)
signal add_item_to_player_inventory(item: Item)
# For Item Mechanics
signal EnemyDamaged(enemy: Enemy, attack: Attack)
signal EnemyKilled(enemy: Enemy, attack: Attack)
signal PlayerDamaged(player: Player_Script, attack: Attack)
signal PlayerKilled(player: Player_Script, attack: Attack)
signal RoundEnded(round_number: int)

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
			print("Gained Level Costing: " + str(int(xp_to_next_level)) + " XP Leftover: " + str(int(xp_gained_since_last_level) - int(xp_to_next_level)))
		player.xp = value
	get():
		return xp
var money: float = 0: ## Current Money Held
	set(value):
		money = value
		ui_man.set_money(str(value))
		player.money = value

func _ready() -> void:
	# Ensure only one instance exists
	if instance != null:
		printerr("Error: Only one instance of gamemanager is allowed in the scene!")
		queue_free() 
		return
	instance = self  
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("@level_setter", 0)
	call_deferred("@xp_setter", 0)
	call_deferred("@money_setter", starting_money)
	
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_attachment(1)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_attachment(2)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_attachment(3)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_attachment(4)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_handle(1)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_handle(2)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_handle(3)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_handle(4)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_projectile(1)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_projectile(2)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_projectile(3)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_projectile(4)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(1)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(2)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(3)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(4)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(4)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(4)))
	ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(4)))
	
	
	global_stats.add_stats(character_choice_stats)
	player.player_stats.add_stats(global_stats)
	
	const STATS_VISUAL = preload("res://Scenes/UI/stats_visual.tscn")
	var s = STATS_VISUAL.instantiate()
	add_child(s)
	s.global_position = Vector2(-310, -0)
	s.set_stats(global_stats, "Global Stats")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("ability1") && ui_man.enabled:
		ui_man.shop.stock(3)
	
	if Input.is_action_just_pressed("ability2") && ui_man.enabled:
		ui_man.shop.reroll()
	
	if Input.is_action_just_pressed("ability3") && ui_man.enabled:
		money += 10
		ui_man.storage2.clear()
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_attachment(1)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_attachment(2)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_attachment(3)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_attachment(4)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_handle(1)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_handle(2)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_handle(3)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_handle(4)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_projectile(1)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_projectile(2)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_projectile(3)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_projectile(4)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(1)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(2)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(3)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(4)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(4)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(4)))
		ui_man.storage2.add(ShopManager.make_itemUI(ShopManager.get_weapon(4)))
	
	if Input.is_action_just_pressed("test_3"):
		pass#ui_man.inventory.add(preload("res://Scripts/flamethrower_scripts/fire_projectile.gd").new())
	
	if Input.is_action_just_pressed("test_4"):
		pass#ui_man.inventory.add(preload("res://Scripts/flamethrower_scripts/flamethrower_attachment.gd").new())
	
	if Input.is_action_just_pressed("test_5"):
		pass#ui_man.inventory.add(preload("res://Scripts/flamethrower_scripts/flamethrower_handle.gd").new())
	
	if Input.is_action_just_pressed("test_6"):
		pass

func sell_item(item: ItemUI) -> bool:
	if (item && item.data.can_sell):
		money += item.data.item_buy_cost * item.data.item_sell_cost_modifier
		return true
	return false

func buy_item(item: ItemUI) -> bool:
	if (item && (money > item.data.item_buy_cost)):
		money -= item.data.item_buy_cost
		return true
	return false

func add_item_to_player(item: Item) -> bool:
	if (item):
		active_items.append(item)
		return true #TODO: add
	return false

func remove_item_from_player(item: Item) -> bool:
	if item && active_items.has(item):
		active_items.erase(item)
		return true #TODO: remove
	return false

func remove_weapon_from_player(weapon: ItemWeapon) -> bool:
	if weapon && weapon.is_ready:
		if !weapon.frame_ready:
			weapon.make_frame()
		if player.remove_frame(weapon.weapon):
			weapon.equipped = false
			return true
	return false

func craft_weapon(handle: ItemUI, attachment: ItemUI, projectile: ItemUI) -> bool:
	if (handle && attachment && projectile) && (handle.data.item_type == ItemData.HANDLE && attachment.data.item_type == ItemData.ATTACHMENT && projectile.data.item_type == ItemData.PROJECTILE):

		var weapon_item: ItemWeapon = ItemWeapon.new()
		weapon_item.setup(attachment.item, handle.item, projectile.item)
		weapon_item.make_frame()
		var n = ItemUI.SCENE.instantiate()
		n.set_item(weapon_item)
		
		if add_weapon_to_player(weapon_item): #TODO: if player can hold more weapons
			ui_man.equipment._add_equipment_weapon(n) # TODO: add weapon item to equipment inventory
			return true
	return false

func add_weapon_to_player(weapon: ItemWeapon) -> bool:
	if weapon && weapon.is_ready:
		if !weapon.frame_ready:
			weapon.make_frame()
		weapon.equipped = true
		player.add_frame(weapon.weapon)
		print("added weapon to player: " + weapon.data.item_name)
		return true
	return false
