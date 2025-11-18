extends Node2D
class_name GameInstance

var TITLE_SCENE

## Sets up the GameInstance by giving parameter values (character should be resource so can change default values?)
func setup(character: Resource, map, run_modifiers) -> void:
	#instantiate character
	#setup gamemanager with starting money
	#call start on gamemanager or enemyspawner or whatever to start game
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TITLE_SCENE = load("res://Scenes/Main/TitleScene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func return_to_main_menu() -> void:
	if TITLE_SCENE == null:
		TITLE_SCENE = load("res://Scenes/Main/TitleScene.tscn")
	get_tree().paused = false
	#change scene
	get_tree().current_scene.queue_free()
	var instance = TITLE_SCENE.instantiate()
	get_tree().root.add_child(instance)
	get_tree().current_scene = instance
