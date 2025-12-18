extends Node2D
class_name Loot

const LOOT_CHEST_UI = preload("uid://bjggm4l8hm8ih")

var title: String
var handle: ItemData
var attachment: ItemData
var projectile: ItemData
var frame: ItemData
var setup_done: bool = false
var ui: Control
var entered: bool = false

func setup(new_title: String, a: ItemData, h: ItemData, proj: ItemData, weaponframe: ItemData):
	attachment = a
	handle = h
	projectile = proj
	frame = weaponframe
	setup_done = true
	title = new_title

func _body_entered(body: Node2D) -> void:
	## If player enters proximity
	if body.is_in_group("player"):
		## Setup Chest UI
		ui = LOOT_CHEST_UI.instantiate()
		ui.button_pressed.connect(toggle_ui)
		GameManager.instance.ui_man.misc_parent.add_child(ui)
		ui.position = Vector2(-800, -400)
		ui.set_text(title, handle.item_name, attachment.item_name, projectile.item_name)
		ui.set_images(handle.item_image, attachment.item_image, projectile.item_image, frame.item_image)
		ui.set_stats(frame.stats)
		var weapon: ItemUI = ShopManager.make_itemUI(frame)
		ui.start()
		## try to move weapon to equipment, backup add it to inventory (equipment full)
		if !GameManager.instance.move_item(weapon, null, GameManager.instance.ui_man.equipment):
			GameManager.instance.ui_man.inventory.backend_add(weapon)
		GameManager.instance.ui_man.pause_misc(true)
		entered = true

func toggle_ui():
	if entered:
		ui.queue_free()
		entered = false
		GameManager.instance.ui_man.pause_misc(false)
		queue_free()
