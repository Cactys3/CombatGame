extends Node

@export var callee: Node2D

func _ready() -> void:
	if !callee && get_parent():
		callee = get_parent()

func damage(attack: Attack):
	callee.damage(attack)
