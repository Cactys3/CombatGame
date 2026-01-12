extends PanelContainer
class_name DismantlePanel
const FORGE_ITEM = preload("uid://xn3lii5356op")

## Images
@onready var handle_texture: TextureRect = $VBoxContainer/TextureParent/HandleTexture
@onready var attachment_texture: TextureRect = $VBoxContainer/TextureParent/AttachmentTexture
@onready var projectile_texture: TextureRect = $VBoxContainer/TextureParent/ProjectileTexture
## Buttons
@onready var confirm_button: Button = $VBoxContainer/ButtonParent/ConfirmButton
@onready var cancel_button: Button = $VBoxContainer/ButtonParent/CancelButton
## Labels
@onready var title: Label = $VBoxContainer/Title
@onready var body: Label = $VBoxContainer/Body
var inventory: MainInventory
var weapon: ItemUI
func _ready() -> void:
	cancel_button.pressed.connect(cancel)
	confirm_button.pressed.connect(confirm)
func setup(inven: MainInventory, weap: ItemUI):
	weapon = weap
	body.text = "Are you sure you want to dismantle your " + weapon.data.item_name + "?"
	inventory = inven
	handle_texture.texture = weapon.data.handle_visual
	attachment_texture.texture = weapon.data.attachment_visual
	projectile_texture.texture = weapon.data.projectile_visual
func cancel():
	reset()
func confirm():
	inventory.backend_remove(weapon)
	GameManager.instance.ui_man.inventory.backend_add(ShopManager.make_itemUI(weapon.data.handle))
	GameManager.instance.ui_man.inventory.backend_add(ShopManager.make_itemUI(weapon.data.attachment))
	GameManager.instance.ui_man.inventory.backend_add(ShopManager.make_itemUI(weapon.data.projectile))
	reset()
func reset():
	inventory.show_side()
	inventory = null
	title.text = "Are you sure you want to dismantle: "
	handle_texture.texture = null
	attachment_texture.texture = null
	projectile_texture.texture = null
	confirm_button.text = "Confirm Dismantle"
	if confirm_button.pressed.is_connected(confirm):
		confirm_button.pressed.disconnect(confirm)
