extends Enemy
class_name Boss
const PROXIMITY_LOOT_CHEST = preload("uid://cll8qcsho5mrw")
@export var loot_drop_title: String = "You got a Random Weapon!"
@export var unlocks_weapon_id: String = "fake"
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
	if unlocks_weapon_id != "fake":
		Save.unlock_weapon(unlocks_weapon_id)

func get_burn_damage() -> float:
	return super()
func get_frost_damage_reduction() -> float:
	return super()
func get_shock_defense_reduction() -> float:
	return super()
## BOSS: only -1 movement speed instead of -4
func get_wet_movement_reduction() -> float:
	## 4 base * number of times threshold has been reached
	return -1 * 1 * floor(wet / wet_threshhold)
## BOSS: only 10 percent max hp dmg for bosses (instead of 50)
func get_bleed_damage() -> float:
	var mulitplier: float = floor(bleed / bleed_threshhold)
	return (max_health * 0.10)
## BOSS: 5 percent of max hp every 2 seconds instead of 25
func get_poison_damage() -> float:
	var mulitplier: float = floor(poison / poison_threshhold)
	return max_health * 0.05 * mulitplier
