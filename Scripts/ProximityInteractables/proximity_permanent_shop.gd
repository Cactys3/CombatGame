extends Node2D
const SHOP = preload("uid://chasb2r7dpbfx")
var pause: UIManager.PauseItem
var shop
var entered: bool = false
var choices: Array[ItemData]
var confirmation: Control
var showing_shop: bool = false

func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
	call_deferred("setup")
func flash():
	await get_tree().create_timer(0.05).timeout
	visible = true
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
	## Forge
	choices.append(ShopManager.get_forge())
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
	if GameManager.instance.buy_item(data):
		choices.erase(data)
		GameManager.instance.ui_man.inventory.backend_add(ShopManager.make_itemUI(data))
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
	var ui = GameManager.instance.ui_man
	ui.pause(UIManager.PauseItem.new(delete_shop, UIManager.PauseItem.PauseTypes.ui, true, false, ui.misc_parent))
func delete_shop():
	showing_shop = false
	if shop:
		shop.queue_free()
