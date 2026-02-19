extends Sprite2D
class_name FlashFixSprite
func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.1).timeout
	visible = true
