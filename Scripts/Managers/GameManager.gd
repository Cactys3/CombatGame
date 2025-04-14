extends Node
class_name GameManager

## Singleton
static var instance: GameManager = self
## Managers
@export var ui_man: UIManager 
@export var shop_man: ShopManager
@export var instance_man: InstanceManager
@export var player: Player_Script

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):
		#ui_man.toggle_inventory()
		toggle_inventory.emit()

	if Input.is_action_just_pressed("ability1") && ui_man.enabled:
		# TODO: this is not where items should be added or smth idk how whatever gets access to inventory
		var item = preload("res://Scripts/flamethrower_scripts/flamethrower_attachment.gd").new()
		var i: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		i.set_item(item)
		ui_man.shop.add(i)
		
		i = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		item = preload("res://Scripts/flamethrower_scripts/flamethrower_handle.gd").new()
		i.set_item(item)
		ui_man.shop.add(i)

	if Input.is_action_just_pressed("ability2") && ui_man.enabled:
		var item = preload("res://Scripts/flamethrower_scripts/fire_projectile.gd").new()
		var i: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		i.set_item(item)
		ui_man.inventory.add(i)
	
	
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
		return true #TODO: player.add_item(item.item)
	return false

func add_weapon_to_player(item: ItemUI) -> bool:
	if (item):
		player.add_frame(item.item) #TODO: if player can hold more weapons
		return true
	return false
