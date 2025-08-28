extends Resource
class_name ItemData
## Generic Fields (always active)
@export_category("Generic Fields (always active)")
@export var item_packed_scene: PackedScene
@export var item_name: String = "default name"
@export var item_description: String = "default description"
enum item_types{unset, handle, attachment, projectile, weapon, item, mod}
@export var item_type: item_types
#@export var item_type: String = "default type"
@export var item_color: Color = Color.DARK_SLATE_BLUE
@export var item_image: Texture2D = preload("res://Art/UI/MissingTexture.png")
@export var randomizable: bool = false
## Misc Fields (common, but not always active)
@export_category("Misc Fields (common, but not always active)")
@export var default_stats: StatsResource = null
@export var default_status_effects: StatusEffects = null
@export var rarity_stat_modifiers: StatsResource = null
@export var rarity_status_effects_modifiers: StatusEffects = null
var stats: StatsResource = null
var status_effects: StatusEffects = null
@export var rarity_cost_modifier = 1
enum item_rarities {unset, common, rare, epic, legendary, exclusive}
@export var item_rarity: item_rarities
#@export var item_rarity: String = "default rarity"
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

var ready: bool = false
static var count: int = 0
var ID: int 

## OLD
func setdata(namae: String, description: String, type: String, rarity: String, color: Color, image: Texture2D, buycost: float, sellmodifier: float):
	item_name = namae
	item_description = description
#	item_type = type
	#item_rarity = rarity
	item_color = color
	item_image = image
	item_buy_cost = buycost
	item_sell_cost_modifier = sellmodifier
	ready = true

## happens only once when itemdata is created
func setup(randomize: bool, rarity: item_rarities):
	if has_stats:
		stats = default_stats.duplicate()
	if has_status_effects:
		status_effects = default_status_effects.duplicate()
	if randomize:
		randomize_stats()
	if has_rarity:
		set_rarity(rarity)

## Changes Variable Values based on rarity, assumes all values are default to begin with
func set_rarity(rarity: item_rarities):
	item_rarity = rarity
	match(item_rarity):
		1:
			item_color = COMMON_COLOR
		2:
			item_color = RARE_COLOR
		3:
			item_color = EPIC_COLOR
		4:
			item_color = LEGENDARY_COLOR
		5:
			item_color = EXCLUSIVE_COLOR
		_:
			item_color = DEFAULT_COLOR
	if item_rarity > 1:
		item_buy_cost = item_buy_cost + (rarity_cost_modifier * item_rarity) #TODO: finalize equation
		for key in stats.statsbase:
			stats.set_stat_base(key, stats.get_stat_base(key) + item_rarity * rarity_stat_modifiers.get_stat_base(key))
			stats.set_stat_factor(key, stats.get_stat_factor(key) + item_rarity * rarity_stat_modifiers.get_stat_factor(key))
		#TODO: Do the same rarity calculations for Status Effects if desired

func randomize_stats():
	pass #TODO: randomize stats variable values

## Instantiates the Item with values
func create_item() -> Node:
	var ret = item_packed_scene.instantiate()
	ret = ret.duplicate()
	if has_stats:
		ret.stats = stats #TODO: Choosing not to duplicate stats here because should be same reference?
	if has_status_effects:
		ret.status_effects = status_effects
	count += 1
	var ID = count
	ret.ID = ID ## TODO: use this ID to track items? useful for matching itemdata to item/weapon when removing
	ret.data = self
	return ret
