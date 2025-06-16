extends Camera2D
@export var target: CharacterBody2D          
func _process(delta: float) -> void:
	if target:
		pass#global_position = target.global_position
