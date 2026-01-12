extends Node
class_name Item

var connect_all: bool = false
var data: ItemData = ShopManager.BLANK_ITEMDATA.duplicate()
var enabled: bool = false
var manager: GameManager:
	get():
		return GameManager.instance

func _process(_delta: float) -> void:
	pass

func _ready() -> void:
	call_deferred("_connect_signals")

func getdata() -> ItemData:
	return data

func _connect_signals():
	if connect_all:
		manager.enemy_damaged.connect(enemy_damaged)
		manager.enemy_killed.connect(enemy_killed)
		manager.player_damaged.connect(player_damaged)
		manager.player_Killed.connect(player_Killed)
		manager.RoundEnded.connect(round_ended)


## Should be overriden by extender to turn off functionality
func enable():
	enabled = true

func disable():
	enabled = false

## signals to be overriden by extender
func setdata():
	pass
func enemy_damaged(enemy: Enemy, attack: Attack):
	pass
func enemy_killed(enemy: Enemy, attack: Attack):
	pass
func player_damaged(player: Character, attack: Attack):
	pass
func player_Killed(player: Character, attack: Attack):
	pass
func round_ended(round_number: int):
	pass
static func get_level_upgrades(itemdata: ItemData) -> Array[ItemData.LevelUpgrade]:
	var arr: Array[ItemData.LevelUpgrade]
	var u1: ItemData.LevelUpgrade = ItemData.LevelUpgrade.new()
	#var damage = randf_range(2, 4)
	#u1.setup(StatsResource.DAMAGE, "Add " + str(damage) + " Damage!", false, damage)
	#arr.append(u1)
	return arr

## Returns a randomized stat object, using the given itemdata's variables like rarity
static func randomize_stats(itemdata: ItemData) -> StatsResource:
	var stats: StatsResource = StatsResource.BLANK_STATS.duplicate()
	stats.setup("RNGrolls")
	stats.set_stat_base(StatsResource.DAMAGE, randi_range(0, 10))
	return stats
## Sets up a RightClickMenu for this component
func setup_right_click_menu(menu: RightClickMenu):
	menu.set_bools(data.can_feed, data.can_sell, false, false)

func get_stats():
	return null

func is_forge() -> bool:
	return false
