extends Resource
class_name ItemData
var item_name: String = "default name"
var item_description: String = "default description"
var item_type: String = "default type"
var item_rarity: String = "default rarity"
var item_color: Color = Color.DARK_SLATE_BLUE
var item_image: Texture2D = preload("res://Art/UI/MissingTexture.png")
var item_buy_cost: float = 5
var item_sell_cost_modifier: float = 0.8
var ready: bool = false
var can_sell: bool = true

const MISSINGTEXTURE = preload("res://Art/UI/MissingTexture.png")
const HANDLE = "handle"
const ATTACHMENT = "attachment"
const PROJECTILE = "projectile"
const ITEM = "item"
const MOD = "mod"
const WEAPON = "weapon"

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
