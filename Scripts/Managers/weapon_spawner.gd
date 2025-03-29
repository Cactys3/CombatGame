extends Node

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sword = preload("res://Scenes/sword.tscn")
@onready var gun = preload("res://Scenes/LazarGun.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_1"):
		var new_weapon:Weapon = sword.instantiate()
		new_weapon.position = Vector2(0, 0)
		player.add_weapon(new_weapon)
	if Input.is_action_just_pressed("test_3"):
		var new_weapon:Weapon = gun.instantiate()
		new_weapon.position = Vector2(0, 0)
		player.add_weapon(new_weapon)
