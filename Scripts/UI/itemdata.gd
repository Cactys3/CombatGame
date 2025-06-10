extends Resource
class_name ItemData
## Generic Fields (always active)
var item_packed_scene: PackedScene
var item_name: String = "default name"
var item_description: String = "default description"
var item_type: String = "default type"
var item_color: Color = Color.DARK_SLATE_BLUE
var item_image: Texture2D = preload("res://Art/UI/MissingTexture.png")
var ready: bool = false
## WeaponFrame Fields (only for weapons)
var attachment = null
var handle = null
var projectile = null
## Item Fields (only for items)
var stackable: bool = true
var count: int = 0 # num of this item already owned (check via gamemanager)
## Common Fields (common, but not always active)
var stats: StatsResource = null
var status_effects: StatusEffects = null
var item_rarity: String = "default rarity"
var item_buy_cost: float = 5
var item_sell_cost_modifier: float = 0.8
## Booleans for optional Fields
var can_sell: bool = true
var can_buy: bool = true
var has_rarity: bool = true
var has_stats: bool = false
var has_status_effects: bool = false
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
