extends Node2D

const SHOP_INVENTORY = preload("uid://bwuwo8e451bxt")

var shop: ShopInventory
var entered: bool = false

func _ready() -> void:
	call_deferred("connect_signals")

func connect_signals():
	GameManager.instance.ui_man.delete_proximity.connect(toggle_shop)

func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shop = SHOP_INVENTORY.instantiate()
		GameManager.instance.ui_man.tab_menu_parent.add_child(shop)
		shop.position = Vector2(-650, -140)
		shop.num_of_items = 5
		shop.reroll()
		GameManager.instance.ui_man.pause_proximity(true)
		entered = true

func toggle_shop():
	if entered:
		shop.clear()
		shop.queue_free()
		entered = false
