extends Node2D

var instance: GameInstance

@export var camera: Camera2D
@export var game_man: GameManager
@export var ui_man: UIManager
@export var background_parent: Node2D
@export var event_parent: Node2D
@export var enemy_parent: Node2D
@export var xp_parent: Node2D
@export var character_parent: Node2D
@export var weapon_parent: Node2D
@export var spawn_area: CollisionShape2D
@export var spawn_deadzone: CollisionShape2D

func setup_instance(new_instance: GameInstance):
	instance = new_instance
	instance.game_man = game_man
	instance.ui_man = ui_man
	instance.background_parent = background_parent
	instance.event_parent = event_parent
	instance.xp_parent = xp_parent
	instance.character_parent = character_parent
	instance.weapon_parent = weapon_parent
	instance.camera = camera
