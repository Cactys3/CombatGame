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
	drop_chest()
	unlock_weapon()
	super()

func death_signal(attack: Attack):
	GameManager.instance.BossKilled.emit(self, attack)

func drop_chest():
	GameInstance.drop_chest(loot_drop_title, loot_drop_id_handle, loot_drop_id_attachment, loot_drop_id_projectile, global_position)

func unlock_weapon():
	if unlocks_weapon_id != -1:
		Save.unlock_weapon(unlocks_weapon_id)
