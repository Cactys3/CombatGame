extends Node

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var enemy = preload("res://Scenes/first_enemy.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_2"):
		var random_position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		var new_enemy = enemy.instantiate()
		new_enemy.position = random_position 
		add_child(new_enemy)
		pass
