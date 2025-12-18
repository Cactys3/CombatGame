extends Node2D

const SHOP_INVENTORY = preload("uid://bwuwo8e451bxt")
const SHOP = preload("uid://s8jnff8as08f")

var shop
var entered: bool = false
var max_choices: int = 3
var curr_choices: int = 0
var choices: Array[ItemData]

func _ready() -> void:
	call_deferred("connect_signals")
	for i in 3:
		match(randi_range(0, 2)):
			0:
				choices.append(ShopManager.get_handle(ShopManager.get_random_unlocked_weapon_index()))
			1:
				choices.append(ShopManager.get_attachment(ShopManager.get_random_unlocked_weapon_index()))
			2:
				choices.append(ShopManager.get_projectile(ShopManager.get_random_unlocked_weapon_index()))

func connect_signals():
	GameManager.instance.ui_man.delete_proximity.connect(toggle_shop)

func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shop = SHOP.instantiate()
		GameManager.instance.ui_man.tab_menu_parent.add_child(shop)
		shop.position = Vector2(650, -140)
		shop.setup(activate_option, max_choices)
		for choice in choices:
			shop.add_option(choice)
		entered = true
		GameManager.instance.ui_man.pause_proximity(true)

func toggle_shop():
	if entered:
		shop.queue_free()
		entered = false
		GameManager.instance.ui_man.pause_proximity(false)

func activate_option(data: ItemData) -> bool:
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
