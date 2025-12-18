extends Enemy
class_name Boss
const PROXIMITY_LOOT_CHEST = preload("uid://cll8qcsho5mrw")
@export var loot_drop_title: String = "You got a Random Weapon!"
@export var unlocks_weapon_id: int = -1
@export var loot_drop_id_handle: int = -1
@export var loot_drop_id_attachment: int = -1
@export var loot_drop_id_projectile: int = -1

## save loot chest on drop resource/scene

## handle dropping loot chest on death

## handle unlocking new weapons on death if that happens

## handle health bar to see if we want that just for bosses

func die():
	drop_loot()
	unlock_weapon()
	super()

func drop_loot():
	#print("SPAWNING CHEST")
	var loot: Loot = PROXIMITY_LOOT_CHEST.instantiate()
	var loot_handle: ItemData
	var loot_attachment: ItemData
	var loot_projectile: ItemData
	var loot_weapon: ItemData
	if loot_drop_id_handle != -1:
		loot_handle = ShopManager.get_handle(loot_drop_id_handle)
	else:
		loot_handle = ShopManager.get_handle(ShopManager.get_random_unlocked_weapon_index())
	if loot_drop_id_attachment != -1:
		loot_attachment = ShopManager.get_attachment(loot_drop_id_handle)
	else:
		loot_attachment = ShopManager.get_attachment(ShopManager.get_random_unlocked_weapon_index())
	if loot_drop_id_projectile != -1:
		loot_projectile = ShopManager.get_projectile(loot_drop_id_handle)
	else:
		loot_projectile = ShopManager.get_projectile(ShopManager.get_random_unlocked_weapon_index())
	loot_weapon = ItemData.new()#)#ItemData.item_types.weapon, "weapon", StatsResource.new(), null)
	loot_weapon.set_components(loot_attachment, loot_handle, loot_projectile)
	loot.setup(loot_drop_title, loot_handle, loot_attachment, loot_projectile, loot_weapon)
	loot.visible = false
	GameManager.instance.enemy_parent.add_child(loot)
	loot.position = position
	loot.visible = true

func death_signal():
	GameManager.instance.BossKilled.emit()

func unlock_weapon():
	if unlocks_weapon_id != -1:
		Save.unlock_weapon(unlocks_weapon_id)
