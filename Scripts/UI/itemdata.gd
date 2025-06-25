extends Resource
class_name ItemData
## Generic Fields (always active)
@export_category("Generic Fields (always active)")
@export var item_packed_scene: PackedScene
@export var item_name: String = "default name"
@export var item_description: String = "default description"
enum item_types{unset, handle, attachment, projectile, weapon, item, mod}
@export var item_type_enum: item_types
@export var item_type: String = "default type"
@export var item_color: Color = Color.DARK_SLATE_BLUE
@export var item_image: Texture2D = preload("res://Art/UI/MissingTexture.png")
@export var randomizable: bool = false
## Misc Fields (common, but not always active)
@export_category("Misc Fields (common, but not always active)")
@export var stats: StatsResource = null
@export var status_effects: StatusEffects = null
enum item_rarities {unset, common, rare, epic, legendary, exclusive}
@export var item_rarity_enum: item_rarities
@export var item_rarity: String = "default rarity"
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
## Item Types
const HANDLE = "handle"
const ATTACHMENT = "attachment"
const PROJECTILE = "projectile"
const ITEM = "item"
const MOD = "mod"
const WEAPON = "weapon"
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

func setdata(namae: String, description: String, type: String, rarity: String, color: Color, image: Texture2D, buycost: float, sellmodifier: float):
	item_name = namae
	item_description = description
	item_type = type
	item_rarity = rarity
	item_color = color
	item_image = image
	item_buy_cost = buycost
	item_sell_cost_modifier = sellmodifier
	ready = true

func create_item() -> Node:
	var ret = item_packed_scene.instantiate()
	ret = ret.duplicate()
	if has_stats:
		ret.stats = stats.duplicate()
	if has_status_effects:
		ret.status_effects = status_effects.duplicate()
	count += 1
	var ID = count
	ret.ID = ID ## TODO: use this ID to track items? useful for matching itemdata to item/weapon when removing
	return ret
