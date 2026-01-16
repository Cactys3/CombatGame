extends Resource
class_name Attack

## General Data
var damage: float # Damage of attack
var position: Vector2 # Position of Attack
var buildup: float # Multiply to Status Buildups
## armor shred?
## Attacker Given Data
var attacking_status: StatusEffectDictionary # Attacker's Offensive Status Effects
var attacker: Node2D # Reference to attacker

## IDK if used Data, This can be hidden stats because attacks should slow or stun enemies to feel 'weighty'
## but these aren't the stuns or slows that the status effects make happen
## Currently:
	## Enemy send values based on enemy type to Player 
	## Projectiles send only 'knockback' values to Enemy, calculated based on stats
var stun: float
var slow: float
var knockback: float

## it should include a stats instance right? 
## probably not. 
## No it should, some enemies will have unique ways of being attacked like taking more dmg based on player's current money. 
## Maybe they can just get from game manager?
#var attacker_stats: StatsResource

func _init(dmg: float, pos: Vector2, buildupStat: float, attacker_status: StatusEffectDictionary, attackerNode: Node2D, stunValue: float, slowValue: float, knockbackValue: float):
	damage = dmg
	position = pos
	buildup = buildupStat
	attacking_status = attacker_status
	attacker = attackerNode
	stun = stunValue
	slow = slowValue
	knockback = knockbackValue
