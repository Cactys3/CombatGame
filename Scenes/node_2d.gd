extends Node2D

@export var stat: StatusEffects

var at
var proj
func _ready() -> void:
	proj = preload("res://Scenes/pistol/pistol_bullet.tscn").instantiate()
	at = preload("res://Scenes/pistol/pistol_attachment.tscn").instantiate()

func _process(delta: float) -> void:
	#print("Bleed: " + str(proj.status.attack_bleed))
	#print("Damage: " + str(at.stats.statsbase.get("damage")))
	pass
