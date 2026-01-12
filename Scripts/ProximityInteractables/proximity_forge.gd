extends Node2D

const FORGE = preload("uid://bxdeumld7epke")
const FORGE_INVENTORY = preload("uid://cwomrgi81thyq")
var forge: Forge
var entered: bool = false

func _ready() -> void:
	call_deferred("connect_signals")

func connect_signals():
	GameManager.instance.ui_man.delete_proximity.connect(toggle_forge)

func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		forge = FORGE.instantiate()
		forge.die.connect(toggle_forge)
		forge.die.connect(queue_free)
		GameManager.instance.ui_man.tab_menu_parent.add_child(forge)
		forge.position = Vector2(1389.0, 289.0)
		forge.clear()
		GameManager.instance.ui_man.pause_proximity(true)
		entered = true

func toggle_forge():
	if entered:
		forge.clear()
		forge.queue_free()
		entered = false
		GameManager.instance.ui_man.pause_proximity(false)
