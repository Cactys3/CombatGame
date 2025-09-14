extends Node2D
class_name GameInstance

## Sets up the GameInstance by giving parameter values (character should be resource so can change default values?)
func setup(character: Resource, starting_money: int) -> void:
	#instantiate character
	#setup gamemanager with starting money
	#call start on gamemanager or enemyspawner or whatever to start game
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
