extends Node2D
const POPUP_TEXT = preload("uid://brldrnbhcexcm")
const LOOT_CHEST_UI = preload("uid://bjggm4l8hm8ih")
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
var price: float = 1000000000

var pause: UIManager.PauseItem = null

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
func setup_self():
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
		if !setup_as_item && !setup_as_weapon && !setup_done:
			setup_self()
		
		entered = true
		if confirmation:
			confirmation.queue_free()
		confirmation = Label.new()
		confirmation.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		confirmation.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		confirmation.text = "Press 'E' to buy this random loot!\n$"
		if setup_as_item:
			confirmation.text += str(item.get_cost(false))
			price = item.get_cost(false)
		if setup_as_weapon:
			confirmation.text += str(frame.get_cost(false))
			price = frame.get_cost(false)
		GameManager.instance.ui_man.relative_to_game_parent.add_child(confirmation)
		offset()

func offset():
	confirmation.global_position = WindowManager.instance.convert_small_position(global_position + Vector2(-33, -20))
func _process(delta: float) -> void:
	if entered && Input.is_action_just_released("Accept"):
		activate()

func activate():
	if !GameManager.instance.can_buy(price):
		var popup: PopupText = POPUP_TEXT.instantiate()
		popup.global_position = Vector2.ZERO
		popup.setup("TOO POOR FOR MINE CHEST!", 64, WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(100, 100))
		
		return
	if confirmation:
		confirmation.queue_free()
	## Setup Chest UI
	if setup_as_item:
		pass
	elif setup_as_weapon:
		activate_weapon()
	else:
		activate_weapon()

func activate_weapon():
	ui = LOOT_CHEST_UI.instantiate()
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
