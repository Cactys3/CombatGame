extends Node2D
const SHOP = preload("uid://chasb2r7dpbfx")
const POPUP_TEXT = preload("uid://brldrnbhcexcm")

var shop
var entered: bool = false
var max_choices: int = 3
var curr_choices: int = 0
var choices: Array[ItemData]
var confirmation: Control
var showing_shop: bool = false

func _ready() -> void:
	call_deferred("setup")
func setup():
	GameManager.instance.ui_man.delete_proximity.connect(delete_shop)
	## Make advanced permanent shop weapon choices based on level?
	## Components
	for i in 3:
		match(randi_range(0, 2)):
			0:
				choices.append(ShopManager.get_handle(ShopManager.get_random_unlocked_weapon_index()))
			1:
				choices.append(ShopManager.get_attachment(ShopManager.get_random_unlocked_weapon_index()))
			2:
				choices.append(ShopManager.get_projectile(ShopManager.get_random_unlocked_weapon_index()))
	## Weapons
	choices.append(ShopManager.get_weapon(ShopManager.get_random_unlocked_weapon_index()))
	choices.append(ShopManager.get_weapon(ShopManager.get_random_unlocked_weapon_index()))
	choices.append(ShopManager.get_weapon(ShopManager.get_random_unlocked_weapon_index()))
	## Items
	choices.append(ShopManager.get_item(ShopManager.get_random_unlocked_item_index()))
	choices.append(ShopManager.get_item(ShopManager.get_random_unlocked_item_index()))
	choices.append(ShopManager.get_item(ShopManager.get_random_unlocked_item_index()))
func _process(delta: float) -> void:
	if entered && !showing_shop && Input.is_action_just_released("Accept"):
		create_shop()
func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		entered = true
		if confirmation:
			confirmation.queue_free()
		confirmation = Label.new()
		confirmation.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		confirmation.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		confirmation.text = "Press 'E' to trade!"
		GameManager.instance.ui_man.relative_to_game_parent.add_child(confirmation)
		confirmation.global_position = WindowManager.instance.convert_small_position(global_position + Vector2(-20, -50))
func _body_exited(body: Node2D) -> void:
	if body.is_in_group("player") && entered:
		entered = false
	if confirmation:
		confirmation.queue_free()
func activate_option(data: ItemData) -> bool:
	print("activate option")
	if GameManager.instance.buy_item(data):
		curr_choices += 1
		choices.erase(data)
		GameManager.instance.ui_man.inventory.backend_add(ShopManager.make_itemUI(data))
		if max_choices <= curr_choices:
			GameManager.instance.ui_man.pause_proximity(false)
			shop.queue_free()
			queue_free()
		return true
	return false
func create_shop():
	showing_shop = true
	if confirmation:
		confirmation.queue_free()
	shop = SHOP.instantiate()
	GameManager.instance.ui_man.misc_parent.add_child(shop)
	shop.position = Vector2(600, 289.0)
	shop.setup(activate_option)
	for choice in choices:
		shop.add_option(choice)
	GameManager.instance.ui_man.pause_proximity(true)
func delete_shop():
	showing_shop = false
	if shop:
		shop.queue_free()
