extends Node2D

const LOOTCHESTUI_WEAPON = preload("uid://bjggm4l8hm8ih")
const LOOTCHESTUI_COMPONENT = preload("uid://yqg5pkef3ywh")

var title: String
## Items to display
var handle: ItemData
var attachment: ItemData
var projectile: ItemData
var frame: ItemData
var item: ItemData
## Bools
var setup_done: bool = false
var entered: bool = false
var done: bool = false
var setup_as_weapon: bool = false
var setup_as_item: bool = false
## Dynamic UI
var ui: Control
var confirmation: Control
var price: int = 1000000000
var level: int 
var time: int
var pause: UIManager.PauseItem = null
var price_setup: bool = false

func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.1).timeout
	visible = true
func setup(new_time: int, new_level: int):
	item = ShopManager.get_rand_component()
	level = new_level
	time = new_time
	if randf() > 0.999:
		setup_random_weapon()
	else:
		setup_item("New Component! " + item.item_name, item)
func calculate_price():
	print("caclulating price: " + str(GameInstance.loot_chests_purchased) + " + 20 + " + str(level))
	price =  round((GameInstance.loot_chests_purchased + 1) * (20 + time * randf_range(0.3, 3)))
	price_setup = true
func setup_weapon(new_title: String, a: ItemData, h: ItemData, proj: ItemData, weaponframe: ItemData):
	attachment = a
	handle = h
	projectile = proj
	frame = weaponframe
	setup_done = true
	title = new_title
	setup_as_weapon = true
func setup_item(new_title: String, i: ItemData):
	item = i
	setup_done = true
	title = new_title
	setup_as_item = true
func setup_random_weapon():
	item = ShopManager.get_rand_component()
	setup_item("New Component! " + item.item_name, item)
	return
	handle = ShopManager.get_rand_handle()
	attachment = ShopManager.get_rand_attachment()
	projectile = ShopManager.get_rand_projectile()
	frame = load("uid://bex1ymr7nsxnu").duplicate()
	frame.set_components(attachment, handle, projectile)
	setup_weapon("New Weapon!", attachment, handle, projectile, frame)
func _exited(body: Node2D) -> void:
	## If player enters proximity
	if body.is_in_group("player") && entered:
		entered = false
	if confirmation:
		confirmation.queue_free()
func _entered(body: Node2D) -> void:
	## If player enters proximity
	if body.is_in_group("player") && !entered:
		if !setup_done:
			## Backup Setup for when placed on map from editor
			setup(1, 1)
		## Calc price on Enter not on Load
		if !price_setup:
			calculate_price()
		entered = true
		if confirmation:
			confirmation.queue_free()
		confirmation = Label.new()
		confirmation.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		confirmation.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		confirmation.text = "Press 'E' to buy this random loot!\n$"
		confirmation.text += str(price)
		GameManager.instance.ui_man.relative_to_game_parent.add_child(confirmation)
		offset()
func offset():
	confirmation.global_position = WindowManager.instance.convert_small_position(global_position + Vector2(-33, -20))
func _process(delta: float) -> void:
	if entered && Input.is_action_just_released("Accept"):
		activate()
func activate():
	if !GameManager.instance.buy(price):
		## This shit doesn't work for some fucked up reason when it's preloaded
		var popup: PopupText = load("uid://brldrnbhcexcm").instantiate()
		popup.global_position = Vector2.ZERO
		popup.setup("TOO POOR FOR MINE CHEST!", 64, WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(100, 100))
		return
	if confirmation:
		confirmation.queue_free()
	## Setup Chest UI
	GameInstance.loot_chests_purchased += 1
	if setup_as_item:
		activate_component()
	elif setup_as_weapon:
		activate_weapon()
func activate_component():
	ui = LOOTCHESTUI_COMPONENT.instantiate()
	GameManager.instance.ui_man.misc_parent.add_child(ui)
	ui.position = Vector2(0, -50)
	ui.set_text(title, item.item_name)
	ui.set_images(item.item_image)
	if item.has_stats:
		ui.set_stats(item.stats)
	else:
		ui.remove_stats()
	ui.button_pressed.connect(unpause)
	ui.button_pressed.connect(die)
	ui.start()
	## Add to inventory
	if !is_instance_valid(item):
		printerr("Didn't setup item before trying to activate component - InteractableLootChestComponent is broken")
	else:
		GameManager.instance.ui_man.inventory.backend_add(ShopManager.make_itemUI(item))
	var ui_man = GameManager.instance.ui_man
	pause = UIManager.PauseItem.new(die, UIManager.PauseItem.PauseTypes.ui, false, false, ui_man.misc_parent)
	ui_man.pause(pause)
func activate_weapon():
	ui = LOOTCHESTUI_WEAPON.instantiate()
	GameManager.instance.ui_man.misc_parent.add_child(ui)
	ui.position = Vector2(0, -50)
	ui.set_text(title, handle.item_name, attachment.item_name, projectile.item_name)
	ui.set_images(handle.item_image, attachment.item_image, projectile.item_image, frame.item_image)
	ui.set_stats(frame.stats)
	var weapon: ItemUI = ShopManager.make_itemUI(frame)
	ui.button_pressed.connect(unpause)
	ui.button_pressed.connect(die)
	ui.start()
	## try to move weapon to equipment, backup add it to inventory (equipment full)
	if !GameManager.instance.move_item(weapon, null, GameManager.instance.ui_man.equipment):
		GameManager.instance.ui_man.inventory.backend_add(weapon)
	var ui_man = GameManager.instance.ui_man
	pause = UIManager.PauseItem.new(die, UIManager.PauseItem.PauseTypes.ui, false, false, ui_man.misc_parent)
	ui_man.pause(pause)
func unpause():
	GameManager.instance.ui_man.unpause(pause)
func die():
	ui.queue_free()
	entered = false
	queue_free()
