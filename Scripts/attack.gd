extends Resource
class_name Attack
## General Data
var damage: int
var position: Vector2 # Attacker's Position
## IDK if used Data, This can be hidden stats because attacks should slow or stun enemies to feel 'weighty'
## but these aren't the stuns or slows that the status effects make happen
## Currently:
	## Enemy send values based on enemy type to Player 
	## Projectiles send only 'knockback' values to Enemy, calculated based on stats
var stun: float
var slow: float
var knockback: float
## Elemental Effects
var burning: float 
var frost: float 
var poison: float 
var bleed: float
var shock: float
var wet: float

## it should include a stats instance right? probably not
var attacker_stats: StatsResource
## should it include a reference to the attacker? depending on if anything needs this
var attacker: Node2D
