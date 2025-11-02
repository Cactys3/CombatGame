extends Resource
class_name ItemData
## Generic Fields (always active)
@export_category("Generic Fields (always active)")
@export var item_packed_scene: PackedScene
@export var item_name: String = "default name"
@export var item_description: String = "default description"
enum item_types{unset, handle, attachment, projectile, weapon, item, mod}
@export var item_type: item_types
@export var item_color: Color = Color.DARK_SLATE_BLUE
@export var border_color: Color = Color.WHITE
@export var item_image: Texture2D = preload("res://Art/UI/MissingTexture.png")
@export var randomizable: bool = false
## Misc Fields (common, but not always active)
@export_category("Misc Fields (common, but not always active)")
@export var default_stats: StatsResource = null
@export var default_status_effects: StatusEffects = null
var stats: StatsResource = null
var status_effects: StatusEffects = null
@export var rarity_cost_modifier = 1
enum item_rarities {unset, common, rare, epic, legendary, exclusive}
@export var item_rarity: int
@export var item_buy_cost: float = 5
@export var item_sell_cost_modifier: float = 0.8
## Booleans for optional Fields
@export_category("Booleans for optional Fields")
@export var can_sell: bool = true
@export var can_buy: bool = true
@export var has_rarity: bool = true
@export var has_stats: bool = false
@export var has_status_effects: bool = false
## WeaponFrame Fields (only for weapons)
@export_category("WeaponFrame Fields (only for weapons)")
@export var attachment: ItemData = null
@export var handle: ItemData = null
@export var projectile: ItemData = null
@export var equipped: bool = false
@export var is_ready: bool = false
@export var frame_ready: bool = false
@export var attachment_visual: Texture2D = null
@export var handle_visual: Texture2D = null
## Item Fields (only for items)
@export_category("Item Fields (only for items)")
@export var stackable: bool = false
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

## happens only once when itemdata is created
func setup(randomize_bool: bool, rarity: item_rarities):
	if has_stats:
		stats = default_stats.duplicate()
	if has_status_effects:
		status_effects = default_status_effects.duplicate()
	if randomize_bool:
		randomize_stats()
	if has_rarity:
		set_rarity(rarity)
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
	if item_rarity > 1:
		item_buy_cost = item_buy_cost + (rarity_cost_modifier * item_rarity) #TODO: finalize equation
	DataUpdated.emit()
	#print("emit data updated")

func randomize_stats():
	pass #TODO: randomize stats variable values if desired (pass stats into instance of real item's .randomize_stats() method)

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
	setup(true, item_rarity)
	attachment = new_attachment
	handle = new_handle
	projectile = new_projectile
	frame_ready = true
	item_type = item_types.weapon
	make_frame()

## Set the Item Components and weapon data based on components
func make_frame() -> Weapon_Frame:
	made_item = true
	var new_frame: Weapon_Frame = Weapon_Frame.SCENE.instantiate()
	new_frame.stats = StatsResource.new()
	new_frame.add_attachment(attachment.make_item())
	new_frame.add_handle(handle.make_item())
	new_frame.add_projectile(projectile.make_item())
	new_frame.stats.add_stats(GameManager.instance.global_stats)
	item_buy_cost = attachment.item_buy_cost + handle.item_buy_cost + projectile.item_buy_cost
	item_sell_cost_modifier = (attachment.item_sell_cost_modifier + handle.item_sell_cost_modifier + projectile.item_sell_cost_modifier) / 3
	item_name = attachment.item_name + handle.item_name + projectile.item_name 
	item_description = attachment.item_name + handle.item_name + projectile.item_name
	attachment_visual = attachment.item_image
	handle_visual = handle.item_image
	new_frame.data = self
	item = new_frame
	item_type = item_types.weapon
	item_image # set to combo of all images somehow
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
			print("Adding: " + str(upgrade.change_value) + " to: " + upgrade.stat_name + " of: " + item_name)
			print("Get_Stats(): " + str(stats.get_stat(upgrade.stat_name)))
			print("get_stat_base(): " + str(stats.get_stat_base(upgrade.stat_name)))
			stats.set_stat_base(upgrade.stat_name, stats.get_stat_base(upgrade.stat_name) + upgrade.change_value)
			print("Get_Stats() Post: " + str(stats.get_stat(upgrade.stat_name)))
			print("get_stat_base() Post: " + str(stats.get_stat_base(upgrade.stat_name)))


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

func get_rarity_upgrade_text() -> String:
	return get_rarity(item_rarity) + "-->" + get_rarity(item_rarity + 1)
