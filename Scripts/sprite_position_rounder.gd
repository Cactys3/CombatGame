extends AnimatedSprite2D

@export var Target: Node2D 
@export var Offset: Vector2

func _process(delta: float) -> void:
	pass
	if Target:
		global_position = round(Target.global_position + Offset)
