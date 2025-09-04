extends Node
class_name ShopManager

## has methods to create shops based on things

const FLAMETHROWER_ATTACHMENT = preload("res://Resources/Weapons/Flamethrower/flamethrower_attachment.tres")
const FLAMETHROWER_HANDLE = preload("res://Resources/Weapons/Flamethrower/flamethrower_handle.tres")
const FLAMETHROWER_PROJECTILE = preload("res://Resources/Weapons/Flamethrower/flamethrower_projectile.tres")


static func get_rand_attachment() -> Attachment:
	var data: ItemData
	match randi_range(0, 3):
		0:
			data = FLAMETHROWER_ATTACHMENT.duplicate(true)
			data.setup(true, ItemData.item_rarities.common)
		1:
			return _dup_stats(Attachment.PISTOL.instantiate())
		2:
			return _dup_stats(Attachment.RAILGUN.instantiate())
		3:
			return _dup_stats(Attachment.SWORD.instantiate())
		_:
			return _dup_stats(Attachment.PISTOL.instantiate())
	return data.make_item()

static func get_rand_handle() -> Handle:
	match randi_range(0, 3):
		0:
			return _dup_stats(Handle.FLAMETHROWER.instantiate())
		1:
			return _dup_stats(Handle.PISTOL.instantiate())
		2:
			return _dup_stats(Handle.RAILGUN.instantiate())
		3:
			return _dup_stats(Handle.SWORD.instantiate())
		_:
			return _dup_stats(Handle.PISTOL.instantiate())

static func get_rand_projectile() -> Projectile:
	match randi_range(0, 3):
		0:
			return _dup_stats(Projectile.FLAMETHROWER.instantiate())
		1:
			return _dup_stats(Projectile.PISTOL.instantiate())
		2:
			return _dup_stats(Projectile.RAILGUN.instantiate())
		3:
			return _dup_stats(Projectile.SWORD.instantiate())
		_:
			return _dup_stats(Projectile.PISTOL.instantiate())

static func get_rand_weapon() -> ItemWeapon:
	match randi_range(5, 7):
		0:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.FLAMETHROWER.instantiate()), _dup_stats(Handle.FLAMETHROWER.instantiate()), _dup_stats(Projectile.FLAMETHROWER.instantiate()))
			return w
		1:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.PISTOL.instantiate()), _dup_stats(Handle.PISTOL.instantiate()), _dup_stats(Projectile.PISTOL.instantiate()))
			return w
		2:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.RAILGUN.instantiate()), _dup_stats(Handle.RAILGUN.instantiate()), _dup_stats(Projectile.RAILGUN.instantiate()))
			return w
		3:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.SWORD.instantiate()), _dup_stats(Handle.SWORD.instantiate()), _dup_stats(Projectile.SWORD.instantiate()))
			return w
		_:
			var w = ItemWeapon.new()
			w.setup(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
			return w

static func get_rand_item() -> Item:
	return get_test().make_item()

static func get_rand_equipment() -> Object:
	var ui_man = GameManager.instance.ui_man
	var item
	match randi_range(0, 5):
		0:
			item = get_rand_weapon()
		1:
			item = get_rand_handle()
		2:
			item = get_rand_attachment()
		3:
			item = get_rand_projectile()
		4:
			item = Item.new()
		_:
			item = get_rand_weapon()
	return item

## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_attachment(num: int) -> Attachment:
	match num:
		1:
			return _dup_stats(Attachment.FLAMETHROWER.instantiate())
		2:
			return _dup_stats(Attachment.PISTOL.instantiate())
		3:
			return _dup_stats(Attachment.RAILGUN.instantiate())
		4:
			return _dup_stats(Attachment.SWORD.instantiate())
		_:
			return _dup_stats(get_rand_attachment())

## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_handle(num: int) -> Handle:
	match num:
		1:
			return _dup_stats(Handle.FLAMETHROWER.instantiate())
		2:
			return _dup_stats(Handle.PISTOL.instantiate())
		3:
			return _dup_stats(Handle.RAILGUN.instantiate())
		4:
			return _dup_stats(Handle.SWORD.instantiate())
		_:
			return _dup_stats(get_rand_handle())

## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_projectile(num: int) -> Projectile:
	match num:
		1:
			return _dup_stats(Projectile.FLAMETHROWER.instantiate())
		2:
			return _dup_stats(Projectile.PISTOL.instantiate())
		3:
			return _dup_stats(Projectile.RAILGUN.instantiate())
		4:
			return _dup_stats(Projectile.SWORD.instantiate())
		_:
			return _dup_stats(get_rand_projectile())

## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_weapon(num: int) -> ItemWeapon:
	match num:
		1:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.FLAMETHROWER.instantiate()), _dup_stats(Handle.FLAMETHROWER.instantiate()), _dup_stats(Projectile.FLAMETHROWER.instantiate()))
			return w
		2:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.PISTOL.instantiate()), _dup_stats(Handle.PISTOL.instantiate()), _dup_stats(Projectile.PISTOL.instantiate()))
			return w
		3:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.RAILGUN.instantiate()), _dup_stats(Handle.RAILGUN.instantiate()), _dup_stats(Projectile.RAILGUN.instantiate()))
			return w
		4:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.SWORD.instantiate()), _dup_stats(Handle.SWORD.instantiate()), _dup_stats(Projectile.SWORD.instantiate()))
			return w
		_:
			var w = ItemWeapon.new()
			w.setup(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
			return w

static func _dup_stats(item) -> Object:
	print(item.stats.parent_object_name + str(item.stats.get_stat("damage")))
	item.stats = item.stats.duplicate()
	if item is Projectile:
		item.status = item.status.duplicate()
	return item

static func make_itemUI(item: ItemData) -> ItemUI:
	#item.setdata() OLD
	#var UI: ItemUI = ItemUI.SCENE.instantiate()
	#UI.set_item(item)
	#return UI
	var UI: ItemUI = ItemUI.SCENE.instantiate()
	UI.set_item(item)
	return UI

static func new_make_itemUI(itemdata) -> ItemUI:
	var UI: ItemUI = ItemUI.SCENE.instantiate()
	UI.set_itemdata(itemdata)
	return UI

static func get_test_flame() -> Weapon_Frame:
	var data: ItemData = ItemData.new()
	data.setup(false, ItemData.item_rarities.common)
	var a = FLAMETHROWER_ATTACHMENT.duplicate(true)
	var h = FLAMETHROWER_HANDLE.duplicate(true)
	var p = FLAMETHROWER_PROJECTILE.duplicate(true)
	data.set_components(a, h, p)
	return data.make_frame()

static func get_test() -> ItemData:
	var itemdata: ItemData = preload("res://Resources/Items/DamageBuff/ItemData_DamageBuff.tres")
	itemdata = itemdata.duplicate(true)
	itemdata.setup(true, ItemData.item_rarities.common)
	return itemdata
