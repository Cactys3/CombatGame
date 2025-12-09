extends Node2D
class_name Loot

const LOOT_CHEST_UI = preload("uid://bjggm4l8hm8ih")

var handle: ItemData
var attachment: ItemData
var projectile: ItemData
var setup_done: bool = false
var ui: Control
var entered: bool = false

func setup(a: ItemData, h: ItemData, proj: ItemData):
	attachment = a
	handle = h
	projectile = proj
	setup_done = true

func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui = LOOT_CHEST_UI.instantiate()
		ui.button_pressed.connect(toggle_ui)
		GameManager.instance.ui_man.misc_parent.add_child(ui)
		ui.position = Vector2(-800, -400)
		if setup_done:
			ui.set_text("You Won a Boss's Weapon!", handle.item_name, attachment.item_name, projectile.item_name)
			ui.set_images(handle.item_image, attachment.item_image, projectile.item_image)
		else:
			handle = ShopManager.get_rand_handle()
			attachment = ShopManager.get_rand_attachment()
			projectile = ShopManager.get_rand_projectile()
			ui.set_text("You Won a random weapon!", handle.item_name, attachment.item_name, projectile.item_name)
			ui.set_images(handle.item_image, attachment.item_image, projectile.item_image)
		var weapon: ItemUI = ShopManager.make_itemUI(ShopManager.setup_weapon(attachment, handle, projectile))
		if !GameManager.instance.move_item(weapon, null, GameManager.instance.ui_man.equipment):
			GameManager.instance.ui_man.storage.backend_add(weapon)
		GameManager.instance.ui_man.pause_misc(true)
		entered = true

func toggle_ui():
	if entered:
		ui.queue_free()
		entered = false
		GameManager.instance.ui_man.pause_misc(false)
		queue_free()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	#toggle_ui()
	pass#print("welp")
