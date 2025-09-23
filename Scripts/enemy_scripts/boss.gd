extends Enemy
class_name Boss

const PROXIMITY_LOOT_CHEST = preload("uid://cll8qcsho5mrw")
@export var loot_drop_id: int = -1

## save loot chest on drop resource/scene

## handle dropping loot chest on death

## handle unlocking new weapons on death if that happens

## handle health bar to see if we want that just for bosses

func die():
	drop_loot()
	unlock_weapon()
	super()

func drop_loot():
	var loot: Loot = PROXIMITY_LOOT_CHEST.instantiate()
	if loot_drop_id != -1:
		loot.setup(ShopManager.get_attachment(loot_drop_id), ShopManager.get_handle(loot_drop_id), ShopManager.get_projectile(loot_drop_id))
	loot.visible = false
	GameManager.instance.enemy_parent.add_child(loot)
	loot.position = position
	loot.visible = true

func unlock_weapon():
	pass
