extends Node
class_name ShopManager



## has methods to create shops based on things

static func get_rand_attachment() -> Attachment:
	match randi_range(0, 3):
		0:
			return _dup_stats(Attachment.FLAMETHROWER.instantiate())
		1:
			return _dup_stats(Attachment.PISTOL.instantiate())
		2:
			return _dup_stats(Attachment.RAILGUN.instantiate())
		3:
			return _dup_stats(Attachment.SWORD.instantiate())
		_:
			return _dup_stats(Attachment.PISTOL.instantiate())

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

static func get_rand_item() -> Object:
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

static func make_itemUI(item) -> ItemUI:
	item.setdata()
	var UI: ItemUI = ItemUI.SCENE.instantiate()
	UI.set_item(item)
	return UI
