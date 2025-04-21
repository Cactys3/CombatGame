extends Node
class_name ShopManager



## has methods to create shops based on things

static func get_rand_attachment() -> Attachment:
	match randi_range(0, 3):
		0:
			return Attachment.FLAMETHROWER.instantiate()
		1:
			return Attachment.PISTOL.instantiate()
		2:
			return Attachment.RAILGUN.instantiate()
		3:
			return Attachment.SWORD.instantiate()
	return Attachment.PISTOL.instantiate()

static func get_rand_handle() -> Handle:
	match randi_range(0, 3):
		0:
			return Handle.FLAMETHROWER.instantiate()
		1:
			return Handle.PISTOL.instantiate()
		2:
			return Handle.RAILGUN.instantiate()
		3:
			return Handle.SWORD.instantiate()
	return Handle.PISTOL.instantiate()

static func get_rand_projectile() -> Projectile:
	match randi_range(0, 3):
		0:
			return Projectile.FLAMETHROWER.instantiate()
		1:
			return Projectile.PISTOL.instantiate()
		2:
			return Projectile.RAILGUN.instantiate()
		3:
			return Projectile.SWORD.instantiate()
	return Projectile.PISTOL.instantiate()

static func get_rand_weapon() -> ItemWeapon:
	match randi_range(0, 4):
		0:
			var w = ItemWeapon.new()
			w.setup(Attachment.FLAMETHROWER.instantiate(), Handle.FLAMETHROWER.instantiate(), Projectile.FLAMETHROWER.instantiate())
			return w
		1:
			var w = ItemWeapon.new()
			w.setup(Attachment.FLAMETHROWER.instantiate(), Handle.FLAMETHROWER.instantiate(), Projectile.FLAMETHROWER.instantiate())
			return w
		2:
			var w = ItemWeapon.new()
			w.setup(Attachment.FLAMETHROWER.instantiate(), Handle.FLAMETHROWER.instantiate(), Projectile.FLAMETHROWER.instantiate())
			return w
		3:
			var w = ItemWeapon.new()
			w.setup(Attachment.FLAMETHROWER.instantiate(), Handle.FLAMETHROWER.instantiate(), Projectile.FLAMETHROWER.instantiate())
			return w
	var w = ItemWeapon.new()
	w.setup(get_rand_attachment(), get_rand_handle(), get_rand_projectile())
	return w

static func get_rand_item() -> ItemUI:
	var ui_man = GameManager.instance.ui_man
	
	if Input.is_action_just_pressed("ability1") && ui_man.enabled:
		# TODO: this is not where items should be added or smth idk how whatever gets access to inventory
		#var item = preload("res://Scripts/flamethrower_scripts/flamethrower_attachment.gd").new()
		var item = Attachment.FLAMETHROWER.instantiate()
		var i: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		item.stats = item.stats.duplicate()
		i.set_item(item)
		ui_man.storage2.add(i)
		
		i = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		#item = preload("res://Scripts/flamethrower_scripts/flamethrower_handle.gd").instantiate()
		item = preload("res://Scenes/flamethrower/flamethrower_handle.tscn").instantiate()
		item.stats = item.stats.duplicate()
		i.set_item(item)
		ui_man.storage2.add(i)

	if Input.is_action_just_pressed("ability2") && ui_man.enabled:
		#var item = preload("res://Scripts/flamethrower_scripts/fire_projectile.gd").new()
		var item = preload("res://Scenes/flamethrower/fire_projectile.tscn").instantiate()
		var i: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		item.stats = item.stats.duplicate()
		i.set_item(item)
		ui_man.storage.add(i)
	
	if Input.is_action_just_pressed("ability3") && ui_man.enabled:
		#var item = preload("res://Scripts/flamethrower_scripts/fire_projectile.gd").new()
		var item = preload("res://Scenes/flamethrower/fire_projectile.tscn").instantiate()
		var i: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		item.stats = item.stats.duplicate()
		i.set_item(item)
		ui_man.storage.add(i)
		 
		var item2 = Item.new()
		item2.data.setdata("testitem", "this is a test item", ItemData.ITEM, "1", Color.RED, ItemData.MISSINGTEXTURE, 5, 0.9)
		var i2: ItemUI = preload("res://Scenes/UI/item_ui.tscn").instantiate()
		i2.set_item(item2)
		ui_man.storage.add(i2)
	
	
	return null
