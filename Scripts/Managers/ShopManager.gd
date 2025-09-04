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

## Items
const DAMAGE_BUFF = preload("res://Resources/Items/DamageBuff/DamageBuff.tres")

## Returns Random Attachment
static func get_rand_attachment() -> ItemData:
	var data: ItemData
	match randi_range(0, 3):
		0:
			return setup_data(FLAMETHROWER_ATTACHMENT.duplicate(true))
		1:
			return setup_data(PISTOL_ATTACHMENT.duplicate(true))
		2:
			return setup_data(RAILGUN_ATTACHMENT.duplicate(true))
		3:
			return setup_data(SWORD_ATTACHMENT.duplicate(true))
		_:
			return setup_data(FLAMETHROWER_ATTACHMENT.duplicate(true))
	return data.make_item()
## Returns Random Handle
static func get_rand_handle() -> ItemData:
	match randi_range(0, 3):
		0:
			return setup_data(FLAMETHROWER_HANDLE.duplicate(true))
		1:
			return setup_data(PISTOL_HANDLE.duplicate(true))
		2:
			return setup_data(RAILGUN_HANDLE.duplicate(true))
		3:
			return setup_data(SWORD_HANDLE.duplicate(true))
		_:
			return setup_data(FLAMETHROWER_HANDLE.duplicate(true))
## Returns Random Projectile
static func get_rand_projectile() -> ItemData:
	match randi_range(0, 3):
		0:
			return setup_data(FLAMETHROWER_PROJECTILE.duplicate(true))
		1:
			return setup_data(PISTOL_PROJECTILE.duplicate(true))
		2:
			return setup_data(RAILGUN_PROJECTILE.duplicate(true))
		3:
			return setup_data(SWORD_PROJECTILE.duplicate(true))
		_:
			return setup_data(FLAMETHROWER_PROJECTILE.duplicate(true))
## Returns Random Weapon
static func get_rand_weapon():# -> ItemWeapon:
	match randi_range(5, 7):
		1:
			#var w = ItemWeapon.new()
			#w.setup(_dup_stats(Attachment.FLAMETHROWER.instantiate()), _dup_stats(Handle.FLAMETHROWER.instantiate()), _dup_stats(Projectile.FLAMETHROWER.instantiate()))
			return setup_weapon(FLAMETHROWER_ATTACHMENT.duplicate(true), FLAMETHROWER_HANDLE.duplicate(true), FLAMETHROWER_PROJECTILE.duplicate(true))
		2:
			#var w = ItemWeapon.new()
			#w.setup(_dup_stats(Attachment.PISTOL.instantiate()), _dup_stats(Handle.PISTOL.instantiate()), _dup_stats(Projectile.PISTOL.instantiate()))
			#return w
			return setup_weapon(PISTOL_ATTACHMENT.duplicate(true), PISTOL_HANDLE.duplicate(true), PISTOL_PROJECTILE.duplicate(true))
		3:
			#var w = ItemWeapon.new()
			#w.setup(_dup_stats(Attachment.RAILGUN.instantiate()), _dup_stats(Handle.RAILGUN.instantiate()), _dup_stats(Projectile.RAILGUN.instantiate()))
			#return w
			return setup_weapon(RAILGUN_ATTACHMENT.duplicate(true), RAILGUN_HANDLE.duplicate(true), RAILGUN_PROJECTILE.duplicate(true))
		4:
			#var w = ItemWeapon.new()
			#w.setup(_dup_stats(Attachment.SWORD.instantiate()), _dup_stats(Handle.SWORD.instantiate()), _dup_stats(Projectile.SWORD.instantiate()))
			#return w
			return setup_weapon(SWORD_ATTACHMENT.duplicate(true), SWORD_HANDLE.duplicate(true), SWORD_PROJECTILE.duplicate(true))
		_:
			#var w = ItemWeapon.new()
			#w.setup(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
			#return w
			return setup_weapon(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
## Returns a random equipment from weapon/handle/attachment/handle/item/etc
static func get_rand_equipment() -> Object:
	var ui_man = GameManager.instance.ui_man
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
			equipment = setup_data(DAMAGE_BUFF.duplicate(true))
		_:
			equipment = get_rand_weapon()
	return equipment
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_attachment(num: int) -> ItemData:
	match num:
		1:
			return setup_data(FLAMETHROWER_ATTACHMENT.duplicate(true))
		2:
			return setup_data(PISTOL_ATTACHMENT.duplicate(true))
		3:
			return setup_data(RAILGUN_ATTACHMENT.duplicate(true))
		4:
			return setup_data(SWORD_ATTACHMENT.duplicate(true))
		_:
			return (get_rand_attachment())
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_handle(num: int) -> ItemData:
	match num:
		1:
			return setup_data(FLAMETHROWER_HANDLE.duplicate(true))
		2:
			return setup_data(PISTOL_HANDLE.duplicate(true))
		3:
			return setup_data(RAILGUN_HANDLE.duplicate(true))
		4:
			return setup_data(SWORD_HANDLE.duplicate(true))
		_:
			return (get_rand_handle())
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_projectile(num: int) -> ItemData:
	match num:
		1:
			return setup_data(FLAMETHROWER_PROJECTILE.duplicate(true))
		2:
			return setup_data(PISTOL_PROJECTILE.duplicate(true))
		3:
			return setup_data(RAILGUN_PROJECTILE.duplicate(true))
		4:
			return setup_data(SWORD_PROJECTILE.duplicate(true))
		_:
			return (get_rand_projectile())
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_weapon(num: int) -> ItemData:
	match num:
		1:
			#var w = ItemWeapon.new()
			#w.setup(_dup_stats(Attachment.FLAMETHROWER.instantiate()), _dup_stats(Handle.FLAMETHROWER.instantiate()), _dup_stats(Projectile.FLAMETHROWER.instantiate()))
			return setup_weapon(FLAMETHROWER_ATTACHMENT.duplicate(true), FLAMETHROWER_HANDLE.duplicate(true), FLAMETHROWER_PROJECTILE.duplicate(true))
		2:
			#var w = ItemWeapon.new()
			#w.setup(_dup_stats(Attachment.PISTOL.instantiate()), _dup_stats(Handle.PISTOL.instantiate()), _dup_stats(Projectile.PISTOL.instantiate()))
			#return w
			return setup_weapon(PISTOL_ATTACHMENT.duplicate(true), PISTOL_HANDLE.duplicate(true), PISTOL_PROJECTILE.duplicate(true))
		3:
			#var w = ItemWeapon.new()
			#w.setup(_dup_stats(Attachment.RAILGUN.instantiate()), _dup_stats(Handle.RAILGUN.instantiate()), _dup_stats(Projectile.RAILGUN.instantiate()))
			#return w
			return setup_weapon(RAILGUN_ATTACHMENT.duplicate(true), RAILGUN_HANDLE.duplicate(true), RAILGUN_PROJECTILE.duplicate(true))
		4:
			#var w = ItemWeapon.new()
			#w.setup(_dup_stats(Attachment.SWORD.instantiate()), _dup_stats(Handle.SWORD.instantiate()), _dup_stats(Projectile.SWORD.instantiate()))
			#return w
			return setup_weapon(SWORD_ATTACHMENT.duplicate(true), SWORD_HANDLE.duplicate(true), SWORD_PROJECTILE.duplicate(true))
		_:
			#var w = ItemWeapon.new()
			#w.setup(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
			#return w
			return setup_weapon(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
## Sets ItemData up to be used
static func setup_data(item: ItemData) -> ItemData:
	var data = item.duplicate(true)
	data.setup(true, random_rarity())
	return data
## returns a random ItemData rarity
static func random_rarity() -> int:
	return randi_range(0, ItemData.item_rarities.size())
## Makes an ItemUI for a given ItemData
static func make_itemUI(item: ItemData) -> ItemUI:
	var UI: ItemUI = ItemUI.SCENE.instantiate()
	UI.set_item(item)
	return UI
## Makes an ItemData for Weapon and adds the Components
static func setup_weapon(a: ItemData, h: ItemData, p: ItemData) -> ItemData:
	var data: ItemData = ItemData.new()
	data.setup(true, random_rarity())
	a.setup(true, random_rarity())
	h.setup(true, random_rarity())
	p.setup(true, random_rarity())
	data.set_components(a, h, p)
	return data
