extends Node2D

const FORGE_INVENTORY = preload("uid://cwomrgi81thyq")



var forge: forge_inventory
var entered: bool = false

func _ready() -> void:
	call_deferred("connect_signals")

func connect_signals():
	GameManager.instance.ui_man.delete_proximity.connect(toggle_forge)

func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		forge = FORGE_INVENTORY.instantiate()
		forge.crafted_weapon.connect(toggle_forge)
		GameManager.instance.ui_man.tab_menu_parent.add_child(forge)
		forge.position = Vector2(-650, -140)
		forge.clear()
		GameManager.instance.ui_man.pause_proximity(true)
		entered = true

func toggle_forge():
	if entered:
		forge.clear()
		forge.queue_free()
		entered = false
