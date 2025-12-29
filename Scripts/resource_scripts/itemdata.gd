extends Resource
class_name ItemData
## Generic Fields (always active)
@export var item_packed_scene: PackedScene
@export_placeholder("Name Go Here") var item_name: String = "unset"
@export_multiline var item_description: String = "default description"
@export var item_type: item_types
@export var item_color: Color = Color.DARK_SLATE_BLUE
@export var border_color: Color = Color.WHITE
@export var item_image: Texture2D = preload("res://Art/UI/MissingTexture.png")
@export var item_buy_cost: float = 5
## Misc Fields (common, but not always active)
@export_group("Stats")
@export var has_stats: bool = false
## Should randomized RNG stats be added to stats on setup
@export var randomizable: bool = false
## Can this data be fed to a weapon/component to transfer added stats
@export var can_feed: bool = true
@export var default_stats: StatsResource = null
@export_group("Status")
@export var has_status_effects: bool = false
@export var default_status_effects: StatusEffects = null
@export_group("Rarity")
@export var has_rarity: bool = true
## Cost will be multiplied by this number for each rarity increase
@export var rarity_cost_modifier = 1
@export var item_rarity: item_rarities
@export_group("Buy and Sell")
@export var can_sell: bool = true
@export var can_buy: bool = true
## Selling value will be buy cost multiplied by this number
@export var item_sell_cost_modifier: float = 0.8

## WeaponFrame Fields (only for weapons)
var attachment: ItemData = null
var handle: ItemData = null
var projectile: ItemData = null
var equipped: bool = false
var is_ready: bool = false
var frame_ready: bool = false
var attachment_visual: Texture2D = null
var handle_visual: Texture2D = null
## Variables
enum item_types{unset, handle, attachment, projectile, weapon, item, mod}
enum item_rarities {unset, common, rare, epic, legendary, exclusive}
var status_effects: StatusEffects = null
var stats: StatsResource = null
## Stat object applied to 'Stats' to be passed around between consumed components
var added_stats: StatsResource = null

## Rarity Colors
const DEFAULT_COLOR: Color = Color.GRAY
const COMMON_COLOR: Color = Color.LIME_GREEN
const RARE_COLOR: Color = Color.ROYAL_BLUE
const EPIC_COLOR: Color = Color.MEDIUM_PURPLE
const LEGENDARY_COLOR: Color = Color.GOLDENROD
const EXCLUSIVE_COLOR: Color = Color.ORANGE_RED
## Default Texture
const MISSINGTEXTURE = preload("res://Art/UI/MissingTexture.png")

var item: Node = null
var level: int = 0
var made_item: bool = false
var ready: bool = false
static var count: int = 0
var ID: int 

signal DataUpdated
## NOT SETUP - Pass in all values to setup an ItemData like you would in @export inspector
func initialize(scene: PackedScene, name: String, description: String, type: item_types, color: Color, image: Texture2D, new_randomizable: bool, new_default_stats: StatsResource, new_default_status: StatusEffects, new_rarity_cost_modifier: int, new_rarity: item_rarities, buy_cost: float, sell_cost_modifier: float, new_can_sell: bool, new_can_feed: bool, new_can_buy: bool, new_stackable: bool) -> void:
	item_type = type
	item_name = name
	if new_default_stats:
		default_stats = new_default_stats
	if new_default_status:
		default_status_effects = new_default_status
## Returns rarity for the given rarity_types index
static func get_rarity(i: int) -> String:
	match(i):
		item_rarities.common:
			return "common"
		item_rarities.rare:
			return "rare"
		item_rarities.epic:
			return "epic"
		item_rarities.legendary:
			return "legendary"
		item_rarities.exclusive:
			return "exclusive"
		item_rarities.unset:
			return "unset"
	return "even further beyond"
## Returns type for the given item_types index
static func get_type(i: int) -> String:
	match(i):
		item_types.unset:
			return "unset"
		item_types.handle:
			return "handle"
		item_types.attachment:
			return "attachment"
		item_types.projectile:
			return "projectile"
		item_types.weapon:
			return "weapon"
		item_types.item:
			return "item"
	return "even further beyond"
## Creates ItemData, called Once
func setup(should_randomize: bool, starting_rarity: item_rarities):
	if has_stats:
		stats = default_stats.duplicate()
	if has_status_effects:
		status_effects = default_status_effects.duplicate()
	if has_rarity:
		set_rarity(starting_rarity)
	## TODO: add starting level
	## Must be done last as randomize uses other variables like rarity
	if should_randomize && randomizable:
		randomize_stats()
	else:
		added_stats = StatsResource.new()
	count += 1
	ID = count ## TODO: use this ID to track items? useful for matching itemdata to item/weapon when removing
## Changes Variable Values based on rarity, assumes all values are default to begin with
func set_rarity(rarity: item_rarities):
	item_rarity = rarity
	match(rarity):
		item_rarities.common:
			border_color = COMMON_COLOR
		item_rarities.rare:
			border_color = RARE_COLOR
		item_rarities.epic:
			border_color = EPIC_COLOR
		item_rarities.legendary:
			border_color = LEGENDARY_COLOR
		item_rarities.exclusive:
			border_color = EXCLUSIVE_COLOR
		_:
			border_color = DEFAULT_COLOR
	DataUpdated.emit()
## Calls randomize_stats on instantiated packed scene
func randomize_stats():
	if item:
		added_stats = item.randomize_stats(self)
		stats.add_stats(added_stats)
	elif item_packed_scene:
		var scene = item_packed_scene.instantiate()
		added_stats = scene.randomize_stats(self)
		stats.add_stats(added_stats)
## Instantiates the Item with values
func get_item() -> Node:
	if made_item:
		return item
	match(item_type):
		item_types.weapon:
			if frame_ready:
				return make_frame()
			else:
				push_error("Called make_frame() before components are added to ItemData")
		item_types.item:
			return make_item()
		item_types.handle:
			return make_item()
		item_types.attachment:
			return make_item()
		item_types.projectile:
			return make_item()
		item_types.handle:
			return make_item()
		item_types.mod:
			return make_item()
	return null
## Sets 'Item' to instantiated version based on already setup variables. Returns item
func make_item():
	made_item = true
	## Need all these seperated because godot fucks everything up if we don't type the variable 'ret'
	match(item_type):
		item_types.item:
			var ret: Item = item_packed_scene.instantiate()
			GameManager.instance.add_child(ret)
			if has_stats:
				ret.set_stats(stats) #TODO: Choosing not to duplicate stats here because should be same reference?
			if has_status_effects:
				ret.status = status_effects
			ret.data = self
			item = ret
			return ret
		item_types.weapon:
			return make_frame()
		item_types.attachment:
			var ret: Attachment = item_packed_scene.instantiate()
			if has_stats:
				ret.stats = stats #TODO: Choosing not to duplicate stats here because should be same reference?
			if has_status_effects:
				ret.status = status_effects
			ret.data = self
			item = ret
			return ret
		item_types.handle:
			var ret: Handle = item_packed_scene.instantiate()
			if has_stats:
				ret.stats = stats #TODO: Choosing not to duplicate stats here because should be same reference?
			if has_status_effects:
				ret.status = status_effects
			ret.data = self
			item = ret
			return ret
		item_types.projectile:
			var ret: Projectile = item_packed_scene.instantiate()
			if has_stats:
				ret.stats = stats #TODO: Choosing not to duplicate stats here because should be same reference?
			if has_status_effects:
				ret.status = status_effects
			ret.data = self
			item = ret
			return ret
		_:
			var ret = item_packed_scene.instantiate()
			if has_stats:
				ret.stats = stats #TODO: Choosing not to duplicate stats here because should be same reference?
			if has_status_effects:
				ret.status_effects = status_effects
			ret.data = self
			item = ret
			return ret
## Sets Weapon Components and setsup this ItemData to hold a Weapon
func set_components(new_attachment: ItemData, new_handle: ItemData, new_projectile: ItemData):
	## Setup to be a weapon itemdata
	has_stats = true
	default_stats = StatsResource.new()
	item_type = item_types.weapon
	setup(true, item_rarity)
	attachment = new_attachment
	handle = new_handle
	projectile = new_projectile
	frame_ready = true
	make_frame()
## Set the Item Components and weapon data based on components
func make_frame() -> Weapon_Frame:
	made_item = true
	var new_frame: Weapon_Frame = Weapon_Frame.SCENE.instantiate()
	new_frame.stats = StatsResource.new()
	new_frame.stats.add_stats(GameManager.instance.global_stats)
	new_frame.add_attachment(attachment.make_item())
	new_frame.add_handle(handle.make_item())
	new_frame.add_projectile(projectile.make_item())
	item_buy_cost = attachment.get_cost(false) + handle.get_cost(false) + projectile.get_cost(false)
	item_sell_cost_modifier = (attachment.item_sell_cost_modifier + handle.item_sell_cost_modifier + projectile.item_sell_cost_modifier) / 3
	item_name = attachment.item_name + handle.item_name + projectile.item_name 
	item_description = attachment.item_name + handle.item_name + projectile.item_name
	attachment_visual = attachment.item_image
	handle_visual = handle.item_image
	new_frame.data = self
	new_frame.name = item_name
	item = new_frame
	item_type = item_types.weapon
	item_image # TODO: set to combo of all images somehow
	stats = new_frame.stats
	return new_frame
## Calculates new level's upgrades, returns them in an array of LevelUpgrades
func get_level_upgrades() -> Array:
	var arr: Array[LevelUpgrade]
	level += 1
	if item && item.has_method("get_level_upgrades"):
		arr = item.get_level_upgrades(self)
	elif item_packed_scene:
		var s = item_packed_scene.instantiate()
		if s.has_method("get_level_upgrades"):
			arr = item.get_level_upgrades(self)
		else:
			push_error("Trying to get level upgrade of: " + item_name)
	else:
		push_error("No Packed Scene? Trying to get level upgrade of: " + item_name)
	return arr
## The 'Stats' inside the actual component is just a reference to the 'Stats' this ItemData has, so we can just add stats to this and it works.
func upgrade_component_level(arr: Array[LevelUpgrade]):
	## Get Stats to Upgrade
	## Upgrade them a percent between a random range
	## ItemPackedScene is the object, can do ItemPackedScene.instantiate().upgrade_component_level(stats) if it's static'
	for upgrade in arr:
		if upgrade.factor_stat:
			stats.set_stat_factor(upgrade.stat_name, stats.get_stat_factor(upgrade.stat_name) + upgrade.change_value)
		else:
			#print("Adding: " + str(upgrade.change_value) + " to: " + upgrade.stat_name + " of: " + item_name)
			#print("Get_Stats(): " + str(stats.get_stat(upgrade.stat_name)))
			#print("get_stat_base(): " + str(stats.get_stat_base(upgrade.stat_name)))
			stats.set_stat_base(upgrade.stat_name, stats.get_stat_base(upgrade.stat_name) + upgrade.change_value)
			#print("Get_Stats() Post: " + str(stats.get_stat(upgrade.stat_name)))
			#print("get_stat_base() Post: " + str(stats.get_stat_base(upgrade.stat_name)))
##
func upgrade_component_rarity():
	match(item_rarity):
		item_rarities.unset:
			pass
		item_rarities.common:
			set_rarity(item_rarities.rare)
		item_rarities.rare:
			set_rarity(item_rarities.epic)
		item_rarities.epic:
			set_rarity(item_rarities.legendary)
		item_rarities.legendary:
			set_rarity(item_rarities.exclusive)
		item_rarities.exclusive:
			pass
##
func get_rarity_upgrade_text() -> String:
	return get_rarity(item_rarity) + "-->" + get_rarity(item_rarity + 1)
## Parameter should be added_stats - Adds this item's added_stats to parameter item's added stats so this object can be consumed
func transfer_additional_stats(stats_to_transfer_to: StatsResource):
	if added_stats:
		stats_to_transfer_to.add_stats(added_stats)
## Calculates and returns cost
func get_cost(sell: bool):
	var cost = item_buy_cost
	if sell:
		cost *= item_sell_cost_modifier
	if has_rarity: 
		cost *= rarity_cost_modifier * (item_rarity + 1)
	return cost
## Returns if this is component or not
func is_component() -> bool:
	return item_type == item_types.handle || item_type == item_types.attachment || item_type == item_types.projectile

## Stats can go up or down, multiplied by 1.0 to 1.5 based on rarity of rng roll

class LevelUpgrade:
	var changes: Array[StatChange]
	var setup_complete: bool = false
	func add_stat_change(name: String, factor: bool, value: float):
		var new_change: StatChange = StatChange.new()
		new_change.name = name
		new_change.factor = factor
		new_change.value = value
		changes.append(new_change)
		setup_complete = true
	class StatChange:
		## Stat to add to
		var name: String
		## If false, it's a base stat
		var factor: bool
		## Value to add to the stat
		var value: float
		func setup(new_name: String, new_factor: bool, new_value: float):
			name = new_name
			factor = new_factor
			value = new_value
