extends Node

@export var foreground: Array[AnimatedSprite2D]
@export var background: Array[AnimatedSprite2D]

func setup(new_time: int, new_level: int):
	if foreground:
		for animation in foreground:
			var global_pos: Vector2 = animation.global_position
			animation.reparent(GameInstance.instance.event_foreground_parent)
			animation.global_position = global_pos
	if background:
		for animation in background:
			var global_pos: Vector2 = animation.global_position
			animation.reparent(GameInstance.instance.event_background_parent)
			animation.global_position = global_pos
