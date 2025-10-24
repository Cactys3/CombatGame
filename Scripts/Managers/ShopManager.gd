extends Node
class_name ShopManager

## Weapon Components
const FLAMETHROWER_ATTACHMENT = preload("res://Resources/Weapons/Flamethrower/flamethrower_attachment.tres")
const FLAMETHROWER_HANDLE = preload("res://Resources/Weapons/Flamethrower/flamethrower_handle.tres")
const FLAMETHROWER_PROJECTILE = preload("res://Resources/Weapons/Flamethrower/flamethrower_projectile.tres")
const PISTOL_ATTACHMENT = preload("res://Resources/Weapons/Pistol/Pistol_Attachment.tres")
const PISTOL_PROJECTILE = preload("res://Resources/Weapons/Pistol/Pistol_Projectile.tres")
const PISTOL_HANDLE = preload("res://Resources/Weapons/Pistol/Pistol_Handle.tres")
const RAILGUN_ATTACHMENT = preload("res://Resources/Weapons/Railgun/Railgun_Attachment.tres")
const RAILGUN_HANDLE = preload("res://Resources/Weapons/Railgun/Railgun_Handle.tres")
const RAILGUN_PROJECTILE = preload("res://Resources/Weapons/Railgun/Railgun_Projectile.tres")
const SWORD_ATTACHMENT = preload("res://Resources/Weapons/Sword/Sword_Attachment.tres")
const SWORD_HANDLE = preload("res://Resources/Weapons/Sword/Sword_Handle.tres")
const SWORD_PROJECTILE = preload("res://Resources/Weapons/Sword/Sword_Projectile.tres")
const LIGHTNINGWAND_ATTACHMENT = preload("uid://clly02oxeamom")
const LIGHTNINGWAND_HANDLE = preload("uid://cu6ysxvvobwys")
const LIGHTNINGWAND_PROJECTILE = preload("uid://4kw7nsj5nfn8")
const ICESHARDWAND_ATTACHMENT = preload("uid://jdw6cfs0i7n4")
const ICESHARDWAND_HANDLE = preload("uid://bjawd7hv468np")
const ICESHARDWAND_PROJECTILE = preload("uid://c0dl8tcaqnjry")
const MINIGUN_ATTACHMENT = preload("uid://dijy473l8v6a6")
const MINIGUN_HANDLE = preload("uid://b8d1h262qm51j")
const MINIGUN_PROJECTILE = preload("uid://2ytfi6larlk7")
const PLAYINGCARD_ATTACHMENT = preload("uid://cdjl76edb4lor")
const PLAYINGCARD_HANDLE = preload("uid://i1hoqf7l5n4y")
const PLAYINGCARD_PROJECTILE = preload("uid://qc4mltub7f0n")
const ROCKETLAUNCHER_ATTACHMENT = preload("uid://d2guitpedxrfd")
const ROCKETLAUNCHER_HANDLE = preload("uid://4u1g60mvfky6")
const ROCKETLAUNCHER_PROJECTILE = preload("uid://hnjh1hbninse")
const BOOMERRANG_ATTACHMENT = preload("uid://dmra67x7kmt0d")
const BOOMERRANG_HANDLE = preload("uid://cjti13rulqsp")
const BOOMERRANG_PROJECTILE = preload("uid://dmvjnybu7lt4d")
const GRAVITY_ATTACHMENT = preload("uid://dkes2e3uubcbp")
const GRAVITY_HANDLE = preload("uid://derhf6jups3oa")
const GRAVITY_PROJECTILE = preload("uid://0ji1vavkew0v")


## Items
const DAMAGE_BUFF = preload("uid://c0eepouojdno6")
const RANDOM_STAT = preload("uid://r584yr4r6pbe")

## Arrays
const item_list: Array = [DAMAGE_BUFF, RANDOM_STAT]
const attachment_list: Array = [FLAMETHROWER_ATTACHMENT, PISTOL_ATTACHMENT, RAILGUN_ATTACHMENT, SWORD_ATTACHMENT, ICESHARDWAND_ATTACHMENT, ROCKETLAUNCHER_ATTACHMENT, PLAYINGCARD_ATTACHMENT, LIGHTNINGWAND_ATTACHMENT, MINIGUN_ATTACHMENT, BOOMERRANG_ATTACHMENT, GRAVITY_ATTACHMENT]
const handle_list: Array = [FLAMETHROWER_HANDLE, PISTOL_HANDLE, RAILGUN_HANDLE, SWORD_HANDLE, ICESHARDWAND_HANDLE, ROCKETLAUNCHER_HANDLE, PLAYINGCARD_HANDLE, LIGHTNINGWAND_HANDLE, MINIGUN_HANDLE, BOOMERRANG_HANDLE, GRAVITY_HANDLE]
const projectile_list: Array = [FLAMETHROWER_PROJECTILE, PISTOL_PROJECTILE, RAILGUN_PROJECTILE, SWORD_PROJECTILE, ICESHARDWAND_PROJECTILE, ROCKETLAUNCHER_PROJECTILE, PLAYINGCARD_PROJECTILE, LIGHTNINGWAND_PROJECTILE, MINIGUN_PROJECTILE, BOOMERRANG_PROJECTILE, GRAVITY_PROJECTILE]

## Returns Random Attachment
static func get_rand_attachment() -> ItemData:
	return setup_data(attachment_list.get(get_random_unlocked_weapon_index()).duplicate(true))
## Returns Random Handle
static func get_rand_handle() -> ItemData:
	return setup_data(handle_list.get(get_random_unlocked_weapon_index()).duplicate(true))
## Returns Random Projectile
static func get_rand_projectile() -> ItemData:
	return setup_data(projectile_list.get(get_random_unlocked_weapon_index()).duplicate(true))
## Returns Random Component
static func get_rand_component() -> ItemData:
	match(randi_range(1, 3)):
		1:
			return get_rand_projectile()
		2:
			return get_rand_attachment()
		_:
			return get_rand_handle()
## Returns Random Weapon
static func get_rand_weapon() -> ItemData:
	# (1 / WeaponCount) chance to get weapon composed of random components
	if randf_range(0, attachment_list.size()) == attachment_list.size():
		return setup_weapon(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
	else:
		return get_weapon(get_random_unlocked_weapon_index())
## Returns Random Item
static func get_rand_item() -> ItemData:
	return setup_data((item_list.get(get_random_unlocked_item_index())).duplicate(true))
## Returns a random equipment from weapon/handle/attachment/handle/item/etc
static func get_rand_equipment() -> Object:
	var equipment
	match randi_range(0, 5):
		0:
			equipment = get_rand_weapon()
		1:
			equipment = get_rand_handle()
		2:
			equipment = get_rand_attachment()
		3:
			equipment = get_rand_projectile()
		4:
			equipment = get_rand_item()
		_:
			equipment = get_rand_weapon()
	return equipment
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_attachment(num: int) -> ItemData:
	print(str(num) + " is less than: " + str(attachment_list.size()))
	if num < attachment_list.size() && num > -1:
		print("true, so we return: " + attachment_list.get(num).item_name)
		return setup_data(attachment_list.get(num).duplicate(true))
	print("false")
	return setup_data(attachment_list.get(get_random_unlocked_weapon_index()).duplicate(true))
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_handle(num: int) -> ItemData:
	if num < handle_list.size() && num > -1:
		return setup_data(handle_list.get(num).duplicate(true))
	return setup_data(handle_list.get(get_random_unlocked_weapon_index()).duplicate(true))
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_projectile(num: int) -> ItemData:
	if num < projectile_list.size() && num > -1:
		return setup_data(projectile_list.get(num).duplicate(true))
	return setup_data(projectile_list.get(get_random_unlocked_weapon_index()).duplicate(true))
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_weapon(num: int) -> ItemData:
	return setup_weapon(get_attachment(num), get_handle(num), get_projectile(num))
## 1 = DamageBuff
static func get_item(num: int) -> ItemData:
	match num:
		1:
			return setup_data(DAMAGE_BUFF.duplicate(true))
		_:
			return setup_data(DAMAGE_BUFF.duplicate(true))
## Sets ItemData up to be used
static func setup_data(item: ItemData) -> ItemData:
	var data = item.duplicate(true)
	data.setup(true, random_rarity())
	return data
## returns a random ItemData rarity
static func random_rarity() -> int:
	return randi_range(1, ItemData.item_rarities.size() - 1)
## Makes an ItemUI for a given ItemData
static func make_itemUI(item: ItemData) -> ItemUI:
	var UI: ItemUI = ItemUI.SCENE.instantiate()
	UI.set_item(item)
	return UI
## Makes an ItemData for Weapon and adds the Components
static func setup_weapon(a: ItemData, h: ItemData, proj: ItemData) -> ItemData:
	var data: ItemData = ItemData.new()
	data.has_rarity = true
	data.setup(true, random_rarity())
	a.setup(true, random_rarity())
	h.setup(true, random_rarity())
	proj.setup(true, random_rarity())
	data.set_components(a, h, proj)
	return data
## Returns random unlocked weapon's index
static func get_random_unlocked_weapon_index() -> int:
	return randi_range(0, attachment_list.size() - 1) #TODO: Check if attachment is unlocked?
static func get_random_unlocked_item_index() -> int:
	return randi_range(0, item_list.size() - 1) #TODO: Check if item is unlocked?
