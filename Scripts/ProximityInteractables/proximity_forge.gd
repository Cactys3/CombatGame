extends Node2D
const FORGE = preload("uid://bxdeumld7epke")
const FORGE_INVENTORY = preload("uid://cwomrgi81thyq")
var forge: Forge
var entered: bool = false
var pause: UIManager.PauseItem

func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.05).timeout
	visible = true
func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		forge = FORGE.instantiate()
		forge.die.connect(toggle_forge)
		forge.die.connect(queue_free)
		forge.die.connect(unpause)
		GameManager.instance.ui_man.misc_parent.add_child(forge)
		forge.position = Vector2(1389.0, 289.0)
		forge.clear()
		var ui_man = GameManager.instance.ui_man
		pause = UIManager.PauseItem.new(toggle_forge, UIManager.PauseItem.PauseTypes.ui, true, true, ui_man.misc_parent)
		ui_man.pause(pause)
		entered = true
func unpause():
	GameManager.instance.ui_man.unpause(pause)
func toggle_forge():
	if forge:
		forge.clear()
		forge.queue_free()
	entered = false
