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
	match randi_range(0, 4):
		0:
			var w = ItemWeapon.new()
			var a = Attachment.FLAMETHROWER.instantiate()
			a.stats = a.stats.duplicate()
			w.setup(_dup_stats(Attachment.FLAMETHROWER.instantiate()), _dup_stats(Handle.FLAMETHROWER.instantiate()), _dup_stats(Projectile.FLAMETHROWER.instantiate()))
			return w
		1:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.FLAMETHROWER.instantiate()), _dup_stats(Handle.FLAMETHROWER.instantiate()), _dup_stats(Projectile.FLAMETHROWER.instantiate()))
			return w
		2:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.FLAMETHROWER.instantiate()), _dup_stats(Handle.FLAMETHROWER.instantiate()), _dup_stats(Projectile.FLAMETHROWER.instantiate()))
			return w
		3:
			var w = ItemWeapon.new()
			w.setup(_dup_stats(Attachment.FLAMETHROWER.instantiate()), _dup_stats(Handle.FLAMETHROWER.instantiate()), _dup_stats(Projectile.FLAMETHROWER.instantiate()))
			return w
		_:
			var w = ItemWeapon.new()
			w.setup(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
			return w

static func get_rand_item() -> ItemUI:
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
	item.setdata()
	var UI: ItemUI = ItemUI.SCENE.instantiate()
	UI.set_item(item)
	return UI

static func _dup_stats(item) -> Object:
	item.stats = item.stats.duplicate()
	return item
