extends Camera2D
@export var target: CharacterBody2D          
func _process(delta: float) -> void:
	if target:
		global_position = target.global_position# + Vector2(90, 50)
