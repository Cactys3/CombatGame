extends Node2D

@export var stat: StatusEffects

var at
var proj
func _ready() -> void:
	proj = preload("res://Scenes/Weapons/pistol/pistol_bullet.tscn").instantiate()
	at = preload("res://Scenes/Weapons/pistol/pistol_attachment.tscn").instantiate()
