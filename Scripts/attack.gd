extends Node
class_name Attack
var damage:int
var knockback:float
var position:Vector2
var stun_time:float
enum damage_effects{none, explode, sparks, wind}
var damage_effect: damage_effects = damage_effects.none
