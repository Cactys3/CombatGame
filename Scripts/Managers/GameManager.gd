extends Node
class_name GameManager
## 

@onready var ui_man: UIManager = get_tree().get_first_node_in_group("uimanager")
@onready var shop_man: ShopManager = get_tree().get_first_node_in_group("shopmanager")
@onready var instance_man: InstanceManager = get_tree().get_first_node_in_group("instancemanager")
@onready var player: Player_Script = get_tree().get_first_node_in_group("player")

var character_choice_stats: StatsResource = StatsResource.new()

var global_stats: StatsResource = StatsResource.new()

var xp_to_next_level: float = 100
var xp_gained_since_last_level: float = 0
var xp_modifier_per_level: float = 1.1
var xp_from_past_levels: float = 0
var starting_money: float = 15

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
	# Check if multiple game managers exist (they shouldn't)
	var nodes_with_same_script = get_tree().get_nodes_in_group("gamemanager")
	if nodes_with_same_script.size() > 1:
		push_error("Error: Only one instance of gamemanager is allowed in the scene!")
		queue_free()  # Remove self if multiple exist
		return
	call_deferred("@level_setter", 0)
	call_deferred("@xp_setter", 0)
	call_deferred("@money_setter", starting_money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
